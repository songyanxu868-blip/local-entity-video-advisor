from pathlib import Path


skill_root = Path(__file__).parents[1]
content = "\n".join(
    [
        (skill_root / "SKILL.md").read_text(encoding="utf-8"),
        (skill_root / "references" / "content-framework.md").read_text(encoding="utf-8"),
    ]
)
required_rules = [
    "发现型",
    "信任型",
    "选择型",
    "转化型",
    "关系型",
    "一条视频只承担一个主任务",
    "一个具体问题",
]

missing = [rule for rule in required_rules if rule not in content]
if missing:
    raise SystemExit(f"Missing account-content planning rules: {len(missing)}")

print("PASS: skill classifies account content into five single-task types.")
