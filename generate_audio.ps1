$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$AudioDir = Join-Path $Root "audio"
New-Item -ItemType Directory -Force -Path $AudioDir | Out-Null

$ApiKey = $env:ELEVENLABS_API_KEY
if ([string]::IsNullOrWhiteSpace($ApiKey)) { throw "ELEVENLABS_API_KEY is empty." }
$Headers = @{ "xi-api-key" = $ApiKey }

function Write-Step([string]$Text) {
    Write-Host ("[Cruce] " + $Text) -ForegroundColor Cyan
}

function New-Music([string]$FileName, [string]$Prompt, [int]$LengthMs = 42000) {
    $Out = Join-Path $AudioDir $FileName
    if (Test-Path $Out) { Write-Step "Skipping existing $FileName"; return }
    Write-Step "Music: $FileName"
    $Body = @{
        prompt = $Prompt
        music_length_ms = $LengthMs
        model_id = "music_v2_5"
        force_instrumental = $true
    } | ConvertTo-Json -Compress
    Invoke-WebRequest -Uri "https://api.elevenlabs.io/v1/music?output_format=mp3_48000_192" -Method Post -Headers $Headers -ContentType "application/json" -Body $Body -OutFile $Out
}

function New-Sfx([string]$FileName, [string]$Prompt, [double]$Duration = 0.9, [double]$Influence = 0.55) {
    $Out = Join-Path $AudioDir $FileName
    if (Test-Path $Out) { Write-Step "Skipping existing $FileName"; return }
    Write-Step "SFX: $FileName"
    $Body = @{
        text = $Prompt
        loop = $false
        duration_seconds = $Duration
        prompt_influence = $Influence
        model_id = "eleven_text_to_sound_v3"
    } | ConvertTo-Json -Compress
    Invoke-WebRequest -Uri "https://api.elevenlabs.io/v1/sound-generation?output_format=mp3_44100_128" -Method Post -Headers $Headers -ContentType "application/json" -Body $Body -OutFile $Out
}

# ---------------- MUSIC ----------------
New-Music "campo_theme.mp3" "Seamless instrumental video game adventure loop for a bright countryside world. Warm acoustic guitar, pizzicato strings, light hand percussion, small woodwind flourishes, playful forward motion, 108 BPM, memorable four-bar motif with a contrasting B section, charming but not childish, clean loop point, no vocals." 44000
New-Music "desierto_theme.mp3" "Seamless instrumental adventure game loop for a desert canyon world. Nylon guitar, dry frame drums, marimba, airy flute accents, restrained bass, dusty open atmosphere, 104 BPM, curious and energetic rather than ominous, clear melodic motif and variation, clean loop point, no vocals." 44000
New-Music "volcan_theme.mp3" "Seamless instrumental action-adventure game loop for a volcanic world. Deep toms, urgent staccato strings, low synth pulse, brass accents and fiery percussion, 126 BPM, intense but school-friendly and fun, escalating middle section then clean resolution back to the opening motif, no vocals." 44000
New-Music "selva_theme.mp3" "Seamless instrumental jungle adventure game loop. Marimba, wooden percussion, plucked bass, playful flute and bright mallet melody, 116 BPM, adventurous canopy exploration, rhythmic movement with a mysterious second section, catchy but not repetitive, clean loop point, no vocals." 44000
New-Music "ciudad_theme.mp3" "Seamless instrumental neon city arcade adventure loop. Crisp electronic drums, rounded synth bass, sparkling arpeggios, punchy melodic synth lead, 128 BPM, futuristic and energetic with a heroic B section, polished modern game soundtrack, clean loop point, no vocals." 44000
New-Music "boss_volcan.mp3" "Instrumental video game boss battle loop for a giant volcanic chicken. Driving toms, brass stabs, tense strings, low synth bass, 140 BPM, dramatic and playful rather than scary, strong repeating battle motif with brief breathing space, seamless loop, no vocals." 40000
New-Music "boss_neon.mp3" "Instrumental final boss battle loop for a giant cyber neon chicken above a futuristic city. Synthwave and orchestral hybrid, aggressive electronic drums, pulsing bass, bright arpeggiators, heroic brass-like synth stabs, 150 BPM, exciting final-battle energy with several distinct phrases, seamless loop, no vocals." 44000
New-Music "party_theme.mp3" "Short seamless instrumental victory party loop for a colorful arcade game. Joyful brass-like synths, claps, marimba, upbeat drums, celebratory melody, 124 BPM, playful triumphant ending that loops smoothly, no vocals." 30000

# ---------------- CORE SFX ----------------
New-Sfx "hop.mp3" "Very short charming arcade chicken hop sound: a soft wooden pop with a tiny feather flutter, clean and friendly, no voice." 0.55
New-Sfx "coin.mp3" "Bright satisfying arcade coin pickup chime, two quick sparkling notes, compact and dopamine-rich, clean tail." 0.65
New-Sfx "vocab_correct.mp3" "Friendly video game correct-answer reward: quick rising three-note sparkle with a soft success pop, cheerful and concise." 0.85
New-Sfx "vocab_wrong.mp3" "Gentle video game wrong-answer sound: short descending wooden-synth bloop, clear feedback but not harsh or discouraging." 0.8
New-Sfx "hit.mp3" "Cartoon arcade impact for a chicken getting bumped, short padded thump with a tiny feather poof, not violent." 0.7
New-Sfx "splash.mp3" "Small playful water splash for a cartoon chicken falling into water, quick and clean, no voice." 0.85
New-Sfx "portal.mp3" "Magical arcade level-complete portal sound, bright rising shimmer and warm resolving chime, triumphant but short." 1.2
New-Sfx "rocket.mp3" "Comedic chicken-shaped rocket arrival and launch: quick whoosh upward, cheerful mechanical ignition, energetic arcade feel." 1.4
New-Sfx "buy.mp3" "Arcade shop purchase confirmation, warm cash-register sparkle followed by a short happy chime." 0.9
New-Sfx "train_warning.mp3" "Short stylized railroad crossing warning for a colorful arcade game, two clear warning tones, urgent but not alarming." 1.0

# ---------------- WORLD / OBSTACLE SFX ----------------
New-Sfx "vine_whip.mp3" "Jungle vine sweeping quickly through leaves, soft leafy whip and branch swish, playful game hazard." 0.75
New-Sfx "snap_plant.mp3" "Cartoon carnivorous plant snapping shut, leafy chomp with a soft wooden click, playful not scary." 0.75
New-Sfx "coconut_drop.mp3" "Coconut falling and landing on soft jungle ground, quick descending whoosh and hollow woody thock." 0.85
New-Sfx "traffic_light.mp3" "Futuristic pedestrian traffic light changing state, clean electronic double beep with a tiny relay click." 0.7
New-Sfx "barrier_clank.mp3" "Light construction barrier sliding and locking into place, plastic-metal clack, clean arcade sound." 0.75
New-Sfx "subway_warning.mp3" "Futuristic metro train warning, short station chime followed by a fast approaching electric rail whoosh." 1.2
New-Sfx "drone_beep.mp3" "Small delivery drone target-lock warning, three clean electronic beeps and a tiny servo sound." 0.85
New-Sfx "laser_charge.mp3" "Arcade neon laser grid charging, rising electronic tone with a crisp energy zap at the end, readable warning." 1.0

# ---------------- BOSS SFX ----------------
New-Sfx "boss_egg.mp3" "Large cartoon chicken boss launching an egg projectile, springy pop followed by a fast airy whoosh." 0.7
New-Sfx "boss_gold.mp3" "Golden egg collectible and counterattack cue, rich magical sparkle with an immediate heroic ping." 0.85
New-Sfx "boss_hit.mp3" "Boss damage impact in a colorful arcade game, energetic electric thump with a bright success crackle, not violent." 0.9
New-Sfx "boss_win.mp3" "Final boss defeated arcade fanfare sting, triumphant rising notes, sparkling finish, strong celebration, no voice." 1.8

Write-Host ""
Write-Host "All requested audio files are present in: $AudioDir" -ForegroundColor Green
