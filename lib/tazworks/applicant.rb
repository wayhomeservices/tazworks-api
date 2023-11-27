# frozen_string_literal: true

module Tazworks
  # Tazworks Applicants Model
  class Applicant < Model
    # https://docs.developer.tazworks.com/#097f5a2a-85f5-4bb7-b208-facc7e66b98f
    def self.get(ids)
      RestClient.get("/v1/clients/#{ids[:clientGuid]}/applicants/#{ids[:applicantGuid]}")
    end

    # https://docs.developer.tazworks.com/#8f16d1e6-7ec4-497b-bf89-161be35c53b7
    def self.create(clientGuid, params)
      required_params = %w[firstName lastName email]
      required_params.each do |rp|
        raise ArgumentError, "#{rp} is missing in params hash." unless params.key?(rp.to_sym)
      end

      response = RestClient.post("/v1/clients/#{clientGuid}/applicants", params)

      applicant = Applicant.initialize_from_response({ clientGuid: }, response)
      applicant.ids[:applicantGuid] = applicant.attributes[:applicantGuid]
      applicant
    end

    def self.submit_order(params)
      Tazworks::Order.create(clientGuid, params)
    end

    # https://docs.developer.tazworks.com/#a90fd0b6-2584-4ccd-b22c-f67e8bfa7ffa
    def self.all(clientGuid, params = {})
      raw_response = RestClient.get("/v1/clients/#{clientGuid}/applicants", { params: })
      ApplicantPagedResponse.new(raw_response, { clientGuid: })
    end

    def applicantGuid
      @ids[:applicantGuid]
    end
  end
end
