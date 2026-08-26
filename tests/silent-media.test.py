from pathlib import Path


skill_path = Path(__file__).parents[1] / "SKILL.md"
content = skill_path.read_text(encoding="utf-8")
required_rules = [
    "静音提取",
    "在播放前确认静音",
    "无法在播放前静音",
]

missing = [rule for rule in required_rules if rule not in content]
if missing:
    raise SystemExit(f"Missing silent-media rules: {len(missing)}")

print("PASS: skill requires silent media extraction before playback.")
