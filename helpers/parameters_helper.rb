module ParametersHelper
  def permit_params(*list)
    params.slice(*list).to_hash.symbolize_keys
  end
end