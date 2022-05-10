from typing import List
from pydantic import BaseModel, Field
from models.domain.airlock_request import AirlockRequest


def get_sample_airlock_request(operation_id: str) -> dict:
    return {
    }

#        "id": operation_id,
#        "resourceId": "933ad738-7265-4b5f-9eae-a1a62928772e",
#        "resourcePath": "/workspaces/933ad738-7265-4b5f-9eae-a1a62928772e",
#        "resourceVersion": 0,
#        "status": "not_deployed",
#        "action": "install",
#        "message": "",
#        "createdWhen": 1642611942.423857,
#        "updatedWhen": 1642611942.423857,
#        "steps": [
#            {
#                "stepId": "main",
#                "stepTitle": "deployment for main",
#                "resourceId": "933ad738-7265-4b5f-9eae-a1a62928772e",
#                "resourceTemplateName": "tre-workspace-base",
#                "resourceType": "workspace",
#                "resourceAction": "install",
#                "status": "not_deployed",
#                "updatedWhen": 1642611942.423857
#            }
#        ]
#    }


class AirlockRequestInResponse(BaseModel):
    airlock_request: AirlockRequest

    class Config:
        schema_extra = {
            "example": {
                "airlockrequest": get_sample_airlock_request("7ac667f0-fd3f-4a6c-815b-82d0cb7a2132")
            }
        }


class AirlockRequestInCreate(BaseModel):
    airlock_request: AirlockRequest

    class Config:
        schema_extra = {
            "example": {
                "airlockrequest": get_sample_airlock_request("7ac667f0-fd3f-4a6c-815b-82d0cb7a2132")
            }
        }


class AirlockRequestInList(BaseModel):
    operations: List[AirlockRequest] = Field([], title="Requests")

    class Config:
        schema_extra = {
            "example": {
                "requests": [
                    get_sample_airlock_request("7ac667f0-fd3f-4a6c-815b-82d0cb7a2132"),
                    get_sample_airlock_request("640488fe-9408-4b9f-a239-3b03bc0c5df0")
                ]
            }
        }
