package test

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const basicExampleDir = "examples/basic"
const advancedExampleDir = "examples/advanced"

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix,
	})

	options.TerraformVars = map[string]interface{}{
		"prefix":                  options.Prefix,
		"enterprise_account_name": "DAF Enterprise",
		"owner_iam_id":            "IBMid-664002EWSV", // iam_id for GoldenEye Operations
	}

	return options
}

func setupAdvancedOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix,
	})

	options.TerraformVars = map[string]interface{}{
		"prefix":                      options.Prefix,
		"enterprise_account_name":     "DAF Enterprise",
		"owner_iam_id":                "IBMid-664002EWSV", // iam_id for GoldenEye Operations
		"existing_sm_instance_guid":   permanentResources["secretsManagerGuid"],
		"existing_sm_instance_region": permanentResources["secretsManagerRegion"],
	}

	return options
}

func TestRunBasicExample(t *testing.T) {
	t.Parallel()

	options := setupOptions(t, "enterprise-basic", basicExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunAdvancedExample(t *testing.T) {
	t.Parallel()

	options := setupAdvancedOptions(t, "enterprise-com", advancedExampleDir)

	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}
