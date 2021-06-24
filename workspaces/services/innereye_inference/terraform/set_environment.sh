    export CUSTOMCONNSTR_AZUREML_SERVICE_PRINCIPAL_SECRET=W5djy.mfqKfE2bBd4d4x0__3A.W7GexRx-
    export CUSTOMCONNSTR_API_AUTH_SECRET=729b508c-2356-dcea-fdf3-a35efb13523e
    export CLUSTER=cp-tre100019486
    export WORKSPACE_NAME=ml-mrtre1-ws-0001-svc-3834
    export EXPERIMENT_NAME=main
    export RESOURCE_GROUP=rg-mrtre1-ws-0001
    export SUBSCRIPTION_ID=802df257-6032-4b50-884c-55cb9f074928
    export APPLICATION_ID=1cf8b3f4-2cca-40b0-bcbe-207c7fad689e
    export TENANT_ID=72f988bf-86f1-41af-91ab-2d7cd011db47
    export DATASTORE_NAME=inference_datastore
    export IMAGE_DATA_FOLDER=image_data
    EOF

    az login --service-principal -u '1cf8b3f4-2cca-40b0-bcbe-207c7fad689e' -p 'W5djy.mfqKfE2bBd4d4x0__3A.W7GexRx-' --tenant '72f988bf-86f1-41af-91ab-2d7cd011db47' 
    && git clone https://github.com/microsoft/InnerEye-Inference
    && cd InnerEye-Inference
    && az webapp up --name app-inf-mrtre1-ws-0001-svc-2106 -g rg-mrtre1-ws-0001
