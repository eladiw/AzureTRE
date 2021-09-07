from fastapi import APIRouter, Depends, HTTPException
from pydantic import parse_obj_as
from starlette import status

from api.dependencies.database import get_repository
from api.dependencies.workspace_service_templates import get_workspace_service_template_by_name_from_path
from api.routes.workspace_templates import get_current_template_by_name
from db.errors import EntityVersionExist
from db.repositories.resource_templates import ResourceTemplateRepository
from models.domain.resource import ResourceType
from models.schemas.user_resource_template import UserResourceTemplateInResponse, UserResourceTemplateInCreate
from models.schemas.resource_template import ResourceTemplateInResponse, ResourceTemplateInformationInList
from models.schemas.workspace_service_template import WorkspaceServiceTemplateInCreate, WorkspaceServiceTemplateInResponse
from resources import strings
from services.authentication import get_current_admin_user, get_current_user


router = APIRouter()


@router.get("/workspace-service-templates", response_model=ResourceTemplateInformationInList, name=strings.API_GET_WORKSPACE_SERVICE_TEMPLATES, dependencies=[Depends(get_current_admin_user)])
async def get_workspace_service_templates(template_repo=Depends(get_repository(ResourceTemplateRepository))) -> ResourceTemplateInformationInList:
    templates_infos = template_repo.get_templates_information(ResourceType.WorkspaceService)
    return ResourceTemplateInformationInList(templates=templates_infos)


@router.get("/workspace-service-templates/{service_template_name}", response_model=WorkspaceServiceTemplateInResponse, response_model_exclude_none=True, name=strings.API_GET_WORKSPACE_SERVICE_TEMPLATE_BY_NAME, dependencies=[Depends(get_current_admin_user)])
async def get_current_workspace_service_template_by_name(service_template_name: str, template_repo=Depends(get_repository(ResourceTemplateRepository))) -> WorkspaceServiceTemplateInResponse:
    template = get_current_template_by_name(service_template_name, template_repo, ResourceType.WorkspaceService)
    return parse_obj_as(WorkspaceServiceTemplateInResponse, template)


@router.post("/workspace-service-templates", status_code=status.HTTP_201_CREATED, response_model=WorkspaceServiceTemplateInResponse, response_model_exclude_none=True, name=strings.API_CREATE_WORKSPACE_SERVICE_TEMPLATES, dependencies=[Depends(get_current_admin_user)])
async def register_workspace_service_template(template_input: WorkspaceServiceTemplateInCreate, template_repo=Depends(get_repository(ResourceTemplateRepository))) -> ResourceTemplateInResponse:
    try:
        return template_repo.create_and_validate_template(template_input, ResourceType.WorkspaceService)
    except EntityVersionExist:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=strings.WORKSPACE_TEMPLATE_VERSION_EXISTS)


@router.get("/workspace-service-templates/{service_template_name}/user-resource-templates", response_model=ResourceTemplateInformationInList, name=strings.API_GET_USER_RESOURCE_TEMPLATES, dependencies=[Depends(get_current_user)])
async def get_user_resource_templates_for_service_template(service_template_name: str, template_repo=Depends(get_repository(ResourceTemplateRepository))) -> ResourceTemplateInformationInList:
    template_infos = template_repo.get_templates_information(ResourceType.UserResource, service_template_name)
    return ResourceTemplateInformationInList(templates=template_infos)


@router.get("/workspace-service-templates/{service_template_name}/user-resource-templates/{user_resource_template_name}", response_model=UserResourceTemplateInResponse, response_model_exclude_none=True, name=strings.API_GET_USER_RESOURCE_TEMPLATE_BY_NAME, dependencies=[Depends(get_current_user)])
async def get_current_user_resource_template_by_name(service_template_name: str, user_resource_template_name: str, template_repo=Depends(get_repository(ResourceTemplateRepository))) -> UserResourceTemplateInResponse:
    template = get_current_template_by_name(user_resource_template_name, template_repo, ResourceType.UserResource, service_template_name)
    return parse_obj_as(UserResourceTemplateInResponse, template)


@router.post("/workspace-service-templates/{service_template_name}/user-resource-templates", status_code=status.HTTP_201_CREATED, response_model=UserResourceTemplateInResponse, response_model_exclude_none=True, name=strings.API_CREATE_USER_RESOURCE_TEMPLATES, dependencies=[Depends(get_current_admin_user)])
async def register_user_resource_template(template_input: UserResourceTemplateInCreate, template_repo=Depends(get_repository(ResourceTemplateRepository)), workspace_service_template=Depends(get_workspace_service_template_by_name_from_path)) -> UserResourceTemplateInResponse:
    try:
        return template_repo.create_and_validate_template(template_input, ResourceType.UserResource, workspace_service_template.name)
    except EntityVersionExist:
        raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail=strings.WORKSPACE_TEMPLATE_VERSION_EXISTS)