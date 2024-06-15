package gn

import "context"

type GN interface {
	CheckDb(ctx context.Context) error
}
