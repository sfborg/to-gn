package gn

import "context"

type GN interface {
	CheckDb(ctx context.Context) error
	SetVernNames(ctx context.Context, ch <-chan [][]string) error
}
