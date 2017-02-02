require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:one)
  end

  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should create project' do
    assert_difference('Project.count') do
      post projects_url, params: { project: {
          acme_id:@project.acme_id,
          detail:@project.detail,
          email: "#{@project.email}.com",
          name: "#{@project.name}_test",
          private_pem: @project.private_pem
      } }
    end

    assert_response 201
  end

  test 'should show project' do
    get project_url(@project)
    assert_response :success
  end

  test 'should update project' do
    patch project_url(@project), params: { project: {
        acme_id:@project.acme_id,
        detail:@project.detail,
        email: "#{@project.email}.com",
        name: "#{@project.name}_test",
        private_pem: @project.private_pem
    } }
    assert_response 200
  end

  test 'should destroy project' do
    assert_difference('Project.count', -1) do
      delete project_url(@project)
    end

    assert_response 204
  end
end
