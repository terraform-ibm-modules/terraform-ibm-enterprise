// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testhelper"
)

const basicExampleDir = "examples/basic"
const advancedExampleDir = "examples/advanced"
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var permanentResources map[string]interface{}

// TestMain will be run before any parallel tests, used to read data from yaml for use with tests
func TestMain(m *testing.M) {

	var err error
	permanentResources, err = common.LoadMapFromYaml(yamlLocation)
	if err != nil {
		log.Fatal(err)
	}

	os.Exit(m.Run())
}

func setupOptions(t *testing.T, prefix string, dir string) *testhelper.TestOptions {
	options := testhelper.TestOptionsDefault(&testhelper.TestOptions{
		Testing:      t,
		TerraformDir: dir,
		Prefix:       prefix,
	})

	options.TerraformVars = map[string]interface{}{
		"prefix":                         options.Prefix,
		"enterprise_account_name":        "DAF Enterprise",
		"ibmcloud_enterprise_account_id": "1f27e30e31f0486980cb0b2657d483f7", // pragma: allowlist secret
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
		"prefix":                         options.Prefix,
		"enterprise_account_name":        "DAF Enterprise",
		"ibmcloud_enterprise_account_id": "1f27e30e31f0486980cb0b2657d483f7", // pragma: allowlist secret
		"existing_sm_instance_guid":      permanentResources["secretsManagerGuid"],
		"existing_sm_instance_region":    permanentResources["secretsManagerRegion"],
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

	// need to do setup so that TerraformOptions is created
	options.TestSetup()

	// save the current parallelism value, we will reset to this value later
	currentParallelValue := options.TerraformOptions.Parallelism
	t.Logf("Terratest Parallelism currently set to %d, replacing with 1 for single-threaded apply", currentParallelValue)
	options.TerraformOptions.Parallelism = 1

	// after apply, set parallelism back to default to help quicken remaining steps
	options.PostApplyHook = func(options *testhelper.TestOptions) error {
		t.Logf("Terratest Parallelism will be switched back to %d from single-threaded", currentParallelValue)
		options.TerraformOptions.Parallelism = currentParallelValue
		return nil
	}

	// turn off test setup, already done
	options.SkipTestSetup = true

	// now do full test single-threaded
	output, err := options.RunTestConsistency()
	assert.Nil(t, err, "This should not have errored")
	assert.NotNil(t, output, "Expected some output")
}

func TestRunUpgradeAdvancedExample(t *testing.T) {
	t.Parallel()

	options := setupAdvancedOptions(t, "enterprise-upg", advancedExampleDir)

	output, err := options.RunTestUpgrade()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
		assert.NotNil(t, output, "Expected some output")
	}
}
