package errata

import (
	"bytes"
	"errors"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestGenerate(t *testing.T) {
	tests := []struct {
		name        string
		args        CodeGenConfig
		assertion   func(t *testing.T, output string)
		expectedErr func(err error) (error, bool)
	}{
		{
			name: "basic",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "fixtures/basic.tmpl",
				Package:  "errata",
			},
			assertion: func(t *testing.T, output string) {
				assert.Equal(t, "Basic template with no substitutions", output)
			},
		},
		{
			name: "variable substitution",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "fixtures/substitution.tmpl",
				Package:  "errata",
			},
			assertion: func(t *testing.T, output string) {
				assert.Equal(t, "errata", output)
			},
		},
		{
			name: "golang",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "golang",
				Package:  "errata",
			},
			assertion: func(t *testing.T, output string) {
				assert.Contains(t, output, "func NewCode1Err")
			},
		},
		{
			name: "missing builtin template",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "missing",
				Package:  "errata",
			},
			expectedErr: func(err error) (error, bool) {
				var expected *FileNotFoundErr
				ok := errors.As(err, &expected)
				return expected, ok
			},
		},
		{
			name: "missing provided template",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "fixtures/missing.tmpl",
				Package:  "errata",
			},
			expectedErr: func(err error) (error, bool) {
				var expected *FileNotFoundErr
				ok := errors.As(err, &expected)
				return expected, ok
			},
		},
		{
			name: "template syntax error",
			args: CodeGenConfig{
				Source:   "fixtures/basic.hcl",
				Template: "fixtures/invalid-syntax.tmpl",
				Package:  "errata",
			},
			expectedErr: func(err error) (error, bool) {
				var expected *InvalidSyntaxErr
				ok := errors.As(err, &expected)
				return expected, ok
			},
		},
		{
			name: "validation error: label/arg name clash",
			args: CodeGenConfig{
				Source:   "fixtures/label-arg-clash.hcl",
				Template: "golang",
				Package:  "errata",
			},
			expectedErr: func(err error) (error, bool) {
				var expected *ArgumentLabelNameClashErr
				ok := errors.As(err, &expected)
				return expected, ok
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			var w bytes.Buffer
			err := Generate(tt.args, &w)
			if err != nil {
				// yes, this would be a bit easier with generics, but I don't see this as a compelling enough
				// reason to make the lib depend on >=1.18
				expected, ok := tt.expectedErr(err)
				t.Log(err.Error())
				assert.Truef(t, ok, "Expecting error of type %T", expected)

				return
			}

			if tt.assertion == nil {
				t.Fatalf("Assertion func must be defined for %q", tt.name)
			}
			tt.assertion(t, w.String())
		})
	}
}
