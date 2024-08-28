package code

import "strings"

// ToID converts nomenclatural code string to an integer iD.
// 0 - no info, 1 - ICZN, 2 - ICN, 3 - ICNP, 4 - ICTV.
func ToID(code string) int {
	code = strings.ToLower(code)
	switch code {
	case "iczn":
		return 1
	case "icn":
		return 2
	case "icnp":
		return 3
	case "ictv":
		return 4
	default:
		return 0
	}
}
