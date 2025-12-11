# medium_gcp_mcp_fastapi_api_gateway
Deploying a MCP Server on Cloud Run Behind an API Gateway

Complete details available in the article [Deploying a MCP Server on Cloud Run Behind an API Gateway](https://medium.com/@markwkiehl/deploying-a-mcp-server-on-cloud-run-behind-an-api-gateway-4225b0bee684)

## 🔒 Securing Your MCP Server on Cloud Run with API Gateway

The prior article, "**Deploying an MCP Server on Google Cloud Run**," provided a template for the deployment of a Model Context Protocol (MCP) Server on Google Cloud Run. This subsequent article demonstrates in detail how to deploy that Cloud Run job/service behind an **API Gateway protected by an API Key**.

If you have a Model Context Protocol (MCP) Server running on Google Cloud Run and you want to secure it behind an API Gateway that requires an API Key to access it, this article is for you. This article provides a template for configuring a Google Cloud API Gateway as the front end to your MCP Server. I have also included Windows OS batch files to fully automate deployment and cleanup of the API Gateway.

### 🚀 Quick Start

1.  **Prerequisite:** Do everything outlined in the prior article, "**Deploying an MCP Server on Google Cloud Run**."
2.  **Add Files:** From my Github repository, add the following files to the project folder:
    * `gcp_9_api_gateway.bat`
    * `gcp_api_gateway_add_api_key.bat`
    * `gcp_api_gateway_cleanup.bat`
    * `gcp_api_gateway_client.py`
    * `openapi2-cloudrun.yaml`
3.  **Update Constants:** The file `gcp_constants.bat` has the following additional key/value pairs the subsequent batch files will use: `GCP_API_KEY_DISPLAY_NAME`, `GCP_API_ID`, `GCP_CONFIG_ID`, `GCP_GATEWAY_ID`. The default values are good, unless you need to build another API Gateway, then you should increment the versioned names (v-#-#).
4.  **Deploy the Gateway:** Open up a Windows OS command window and run the batch file **`gcp_9_api_gateway.bat`**. Follow the instructions from the batch file carefully:
    * It will ask you to edit the YAML file `openapi2-cloudrun.yaml` first to create the API Configuration.
    * Later, it will tell you the **URL** and **API Key** that needs to go into the Python script `gcp_api_gateway_client.py`.

> 💡 **Tip:** If you need to create additional API Keys, run the batch file `gcp_api_gateway_add_api_key.bat`.

> 🗑️ **Cleanup:** Use the batch `gcp_api_gateway_cleanup.bat` to delete the API Gateway.