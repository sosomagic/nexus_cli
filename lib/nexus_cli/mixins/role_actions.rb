require 'json'
require 'jsonpath'

module NexusCli
  # @author Chuck Wu <chwu1226@gmail.com>
  module RoleActions


    # Gets information about the current Nexus roles.
    #
    # @return [String] a String of XML with data about Nexus roles
    def get_roles
      response = nexus.get(nexus_url("service/local/roles"))
      case response.status
      when 200
        return response.content
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    # Creates a Role.
    #
    # @param  params [Hash] a Hash of parameters to use during role creation
    #
    # @return [Boolean] true if the role is created, false otherwise
    def create_role(params)
      response = nexus.post(nexus_url("service/local/roles"), :body => create_role_json(params), :header => DEFAULT_CONTENT_TYPE_HEADER)
      case response.status
      when 201
        return true
      when 400
        raise CreateRoleException.new(response.content)
      else
        raise UnexpectedStatusCodeException.new(reponse.code)
      end
    end

    # Gets a role
    #
    # @param  role [String] the name of the role to get
    #
    # @return [Hash] a parsed Ruby object representing the role's JSON
    def get_role(role)
      response = nexus.get(nexus_url("service/local/roles/#{role}"), :header => DEFAULT_ACCEPT_HEADER)
      case response.status
      when 200
        return JSON.parse(response.content)
      when 404
        raise RoleNotFoundException.new(role)
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    # Deletes the Nexus role with the given id.
    #
    # @param  role_id [String] the Nexus role to delete
    #
    # @return [Boolean] true if the role is deleted, false otherwise
    def delete_role(role_id)
      response = nexus.delete(nexus_url("service/local/roles/#{role_id}"))
      case response.status
      when 204
        return true
      when 404
        raise RoleNotFoundException.new(role_id)
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    def create_role(params)
      response = nexus.post(nexus_url("service/local/roles"), :body => create_role_json(params), :header => DEFAULT_CONTENT_TYPE_HEADER)
      case response.status
      when 201
        return true
      when 400
        raise CreateRoleException.new(response.content)
      else
        raise UnexpectedStatusCodeException.new(response.code)
      end
    end

    private

    def create_role_json(params)
      JSON.dump(:data => params)
    end
  end
end
