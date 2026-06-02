"""
Minimal scope guardrail - edit AUTHORIZED_TARGETS before each engagement
"""
import sys
import json

AUTHORIZED_TARGETS = [
    # Add your current program's in-scope domains/IPs here
    # "example.com",
    # "*.example.com",
    # "192.168.1.0/24",
]

def is_in_scope(target: str) -> bool:
    for authorized in AUTHORIZED_TARGETS:
        if authorized.startswith("*."):
            domain = authorized[2:]
            if target.endswith(domain) or target == domain:
                return True
        elif target == authorized or target.endswith("." + authorized):
            return True
    return False

if __name__ == "__main__":
    target = sys.argv[1] if len(sys.argv) > 1 else ""
    result = is_in_scope(target)
    print(json.dumps({"in_scope": result, "target": target}))
    sys.exit(0 if result else 1)
