// Tests in this file are run in the PR pipeline and the continuous testing pipeline
package test

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/common"
	"github.com/terraform-ibm-modules/ibmcloud-terratest-wrapper/testschematic"
)

const fullyConfigFlavorDir = "solutions/fully-configurable"
const yamlLocation = "../common-dev-assets/common-go-assets/common-permanent-resources.yaml"

var validRegions = []string{
	"au-syd",
	"jp-osa",
	"jp-tok",
	"eu-de",
	"eu-gb",
	"eu-es",
	"us-east",
	"us-south",
	"ca-tor",
	"br-sao",
}

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

func TestFullyConfigurable(t *testing.T) {
	t.Parallel()

	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")
	region := validRegions[common.CryptoIntn(len(validRegions))]
	prefix := "ep-da"
	parentCRN := "crn:v1:bluemix:public:enterprise::a/1f27e30e31f0486980cb0b2657d483f7::enterprise:3e4723f82d754ef493651d63bc897ea4"
	primaryContactIAMID := "IBMid-666000KAO3"
	enterpriseAccountConfig := map[string]any{
		"unique_identifier":      "acc-key-1",
		"account_name":           "account_DA",
		"create_account_group":   false,
		"add_owner_iam_policies": true, // this field enable child account to have IAM_APIKey with owner IAM policies
		"owner_iam_id":           "IBMid-664002EWSV",
	}
	accessGroups := map[string]any{
		"my_first_access_group": map[string]any{
			"access_group_name": "team-alpha-access",
			"policies": map[string]any{
				"viewer-policy": map[string]any{
					"roles": []string{"Viewer"},
					"tags":  []string{"project:goldeneye"},
					"resource_attributes": []any{
						map[string]any{
							"name":     "serviceName",
							"value":    "iam-identity",
							"operator": "stringEquals",
						},
					},
				},
				"admin-policy": map[string]any{
					"roles": []string{"Administrator"},
					"tags":  []string{"project:goldeneye"},
					"resource_attributes": []any{
						map[string]any{
							"name":     "service_group_id",
							"value":    "IAM",
							"operator": "stringEquals",
						},
					},
				},
			},
		},
	}
	usersToInvite := []map[string]any{
		{
			"email":                   "goldeneye.development@ibm.com",
			"exisiting_access_groups": []string{"team-alpha-access"},
		},
	}

	// ------------------------------------------------------------------------------------
	// Deploy DA
	// ------------------------------------------------------------------------------------
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Region:  region,
		Prefix:  prefix,
		TarIncludePatterns: []string{
			"*.tf",
			"modules/*/*.tf",
			"modules/*/*.sh",
			fullyConfigFlavorDir + "/*.tf",
		},
		TemplateFolder:         fullyConfigFlavorDir,
		Tags:                   []string{"enterprise-da-test"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "parent_enterprise_account_crn", Value: parentCRN, DataType: "string"},
		{Name: "parent_enterprise_account_primary_contact_iam_id", Value: primaryContactIAMID, DataType: "string"},
		{Name: "enterprise_account_config", Value: enterpriseAccountConfig, DataType: "object"},
		{Name: "access_groups", Value: accessGroups, DataType: "map(object)"},
		{Name: "users_to_invite", Value: usersToInvite, DataType: "list(object)"},
	}
	err := options.RunSchematicTest()
	assert.Nil(t, err, "This should not have errored")

}

func TestUpgradeFullyConfigurable(t *testing.T) {
	t.Parallel()

	checkVariable := "TF_VAR_ibmcloud_api_key"
	val, present := os.LookupEnv(checkVariable)
	require.True(t, present, checkVariable+" environment variable not set")
	require.NotEqual(t, "", val, checkVariable+" environment variable is empty")
	region := validRegions[common.CryptoIntn(len(validRegions))]
	prefix := "ep-upg"
	parentCRN := "crn:v1:bluemix:public:enterprise::a/1f27e30e31f0486980cb0b2657d483f7::enterprise:3e4723f82d754ef493651d63bc897ea4"
	primaryContactIAMID := "IBMid-666000KAO3"
	enterpriseAccountConfig := map[string]any{
		"unique_identifier":      "acc-key-2",
		"account_name":           "account_DA_upg",
		"create_account_group":   false,
		"add_owner_iam_policies": true, // this field enable child account to have IAM_APIKey with owner IAM policies
		"owner_iam_id":           "IBMid-664002EWSV",
	}
	accessGroups := map[string]any{
		"my_first_access_group": map[string]any{
			"access_group_name": "team-alpha-access",
			"policies": map[string]any{
				"viewer-policy": map[string]any{
					"roles": []string{"Viewer"},
					"tags":  []string{"project:goldeneye"},
					"resource_attributes": []any{
						map[string]any{
							"name":     "serviceName",
							"value":    "iam-identity",
							"operator": "stringEquals",
						},
					},
				},
				"admin-policy": map[string]any{
					"roles": []string{"Administrator"},
					"tags":  []string{"project:goldeneye"},
					"resource_attributes": []any{
						map[string]any{
							"name":     "service_group_id",
							"value":    "IAM",
							"operator": "stringEquals",
						},
					},
				},
			},
		},
	}
	usersToInvite := []map[string]any{
		{
			"email":                   "goldeneye.development@ibm.com",
			"exisiting_access_groups": []string{"team-alpha-access"},
		},
	}

	// ------------------------------------------------------------------------------------
	// Deploy DA
	// ------------------------------------------------------------------------------------
	options := testschematic.TestSchematicOptionsDefault(&testschematic.TestSchematicOptions{
		Testing: t,
		Region:  region,
		Prefix:  prefix,
		TarIncludePatterns: []string{
			"*.tf",
			"modules/*/*.tf",
			"modules/*/*.sh",
			fullyConfigFlavorDir + "/*.tf",
		},
		TemplateFolder:         fullyConfigFlavorDir,
		Tags:                   []string{"enterprise-upg-test"},
		DeleteWorkspaceOnFail:  false,
		WaitJobCompleteMinutes: 60,
	})

	options.TerraformVars = []testschematic.TestSchematicTerraformVar{
		{Name: "ibmcloud_api_key", Value: options.RequiredEnvironmentVars["TF_VAR_ibmcloud_api_key"], DataType: "string", Secure: true},
		{Name: "prefix", Value: options.Prefix, DataType: "string"},
		{Name: "parent_enterprise_account_crn", Value: parentCRN, DataType: "string"},
		{Name: "parent_enterprise_account_primary_contact_iam_id", Value: primaryContactIAMID, DataType: "string"},
		{Name: "enterprise_account_config", Value: enterpriseAccountConfig, DataType: "object"},
		{Name: "access_groups", Value: accessGroups, DataType: "map(object)"},
		{Name: "users_to_invite", Value: usersToInvite, DataType: "list(object)"},
	}
	err := options.RunSchematicUpgradeTest()
	if !options.UpgradeTestSkipped {
		assert.Nil(t, err, "This should not have errored")
	}
	assert.Nil(t, err, "This should not have errored")
}
