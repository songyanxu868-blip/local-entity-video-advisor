from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]


def assert_contains(path: Path, phrases: list[str]) -> None:
    text = path.read_text(encoding="utf-8")
    missing = [phrase for phrase in phrases if phrase not in text]
    if missing:
        raise AssertionError(f"{path.name} 缺少范围边界：{missing}")


assert_contains(
    ROOT / "SKILL.md",
    [
        "公域流量边界",
        "私域运营知识",
        "只标注“需要承接”",
        "不输出私域 SOP",
    ],
)
assert_contains(
    ROOT / "references" / "content-framework.md",
    [
        "公域内容任务",
        "不是私域社群运营",
    ],
)

print("public traffic boundary test passed")
