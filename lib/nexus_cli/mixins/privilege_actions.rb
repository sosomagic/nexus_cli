require 'json'
require 'jsonpath'

module NexusCli
  # @author Chuck Wu <chwu1226@gmail.com>
  module PrivilegeActions


    # Gets information about the current Nexus privileges.
    #
    # @return [String] a String of XML with data about Nexus privileges
    def get_privileges
      response = nexus.get(nexus_url("service/local/privileges"))
      case response.status
      when 200
        return response.content
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    # Gets information about the current Nexus privileges types.
    #
    # @return [String] a String of XML with data about Nexus privileges types
    def get_privilege_types
      response = nexus.get(nexus_url("service/local/privilege_types"))
      case response.status
      when 200
        return response.content
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    # Creates a Privilege.
    #
    # @param  params [Hash] a Hash of parameters to use during privilege creation
    #
    # @return [Boolean] true if the privilege is created, false otherwise
    def create_privilege(params)
      response = nexus.post(nexus_url("service/local/privileges_target"), :body => create_privilege_json(params), :header => DEFAULT_CONTENT_TYPE_HEADER)
      case response.status
      when 201
        return true
      when 400
        raise CreatePrivilegeException.new(response.content)
      else
        raise UnexpectedStatusCodeException.new(reponse.code)
      end
    end

    # Gets a privilege
    #
    # @param  privilege [String] the name of the privilege to get
    #
    # @return [Hash] a parsed Ruby object representing the privilege's JSON
    def get_privilege(privilege_id)
      response = nexus.get(nexus_url("service/local/privileges/#{privilege_id}"), :header => DEFAULT_ACCEPT_HEADER)
      case response.status
      when 200
        return JSON.parse(response.content)
      when 404
        raise PrivilegeNotFoundException.new(privilege_id)
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    # Deletes the Nexus privilege with the given id.
    #
    # @param  privilege_id [String] the Nexus privilege to delete
    #
    # @return [Boolean] true if the privilege is deleted, false otherwise
    def delete_privilege(privilege_id)
      response = nexus.delete(nexus_url("service/local/privileges/#{privilege_id}"))
      case response.status
      when 204
        return true
      when 404
        raise PrivilegeNotFoundException.new(privilege_id)
      else
        raise UnexpectedStatusCodeException.new(response.status)
      end
    end

    private

    def create_privilege_json(params)
      JSON.dump(:data => params)
    end
  end
end
