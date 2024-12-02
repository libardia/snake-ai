class_name Util


static func all_in(tests: Array, values: Array) -> bool:
    for t in tests:
        if t not in values:
            return false
    return true
