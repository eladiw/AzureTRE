from typing import List
from enum import Enum
from pydantic import Field
from resources import strings
from models.domain.airlock_resource import AirlockResource, AirlockResourceType


class AirlockRequestStatus(str, Enum):
    """
    Airlock Resource status
    """
    Draft = strings.AIRLOCK_RESOURCE_STATUS_DRAFT
    Submitted = strings.AIRLOCK_RESOURCE_STATUS_SUBMITTED
    WaitForScan = strings.AIRLOCK_RESOURCE_STATUS_WAITING_FOR_SCAN
    InReview = strings.AIRLOCK_RESOURCE_STATUS_INREVIEW
    ApprovalInProgress = strings.AIRLOCK_RESOURCE_STATUS_APPROVAL_INPROGRESS
    Approved = strings.AIRLOCK_RESOURCE_STATUS_APPROVED
    RejectionInProgress = strings.AIRLOCK_RESOURCE_STATUS_REJECTION_INPROGRESS
    Rejected = strings.AIRLOCK_RESOURCE_STATUS_REJECTED
    Cancelled = strings.AIRLOCK_RESOURCE_STATUS_CANCELLED
    ScanInProgress = strings.AIRLOCK_RESOURCE_STATUS_SCAN_INPROGRESS
    BlockingInProgress = strings.AIRLOCK_RESOURCE_STATUS_BLOCKING_INPROGRESS
    Blocked = strings.AIRLOCK_RESOURCE_STATUS_BLOCKED


class AirlockRequestType(str, Enum):
    Import = strings.AIRLOCK_REQUEST_TYPE_IMPORT
    Export = strings.AIRLOCK_REQUEST_TYPE_EXPORT


class AirlockRequest(AirlockResource):
    """
    Airlock request
    """
    workspaceId: str = Field("", title="Workspace ID", description="Service target Workspace id")
    resourceType = AirlockResourceType.AirlockRequest
    requestType: AirlockRequestType = Field("", title="Airlock request type")
    files: List[str] = Field([], title="Files of the request")
    businessJustification: str = Field("Business Justifications", title="Explanation that will be provided to the request reviewer")
    status = AirlockRequestStatus.Draft
