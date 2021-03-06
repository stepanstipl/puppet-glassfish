require 'puppet/provider/asadmin'
Puppet::Type.type(:systemproperty).provide(:asadmin, :parent =>
                                           Puppet::Provider::Asadmin) do
  desc "Glassfish system-properties support."

  def create
    args = Array.new
    args << "create-system-properties"
    args << "'" + @resource[:name] + "=" + escape(@resource[:value]) + "'"
    asadmin_exec(args)
  end

  def destroy
    args = Array.new
    args << "delete-system-property" << "'" + escape(@resource[:name]) + "'"
    asadmin_exec(args)
  end

  def exists?
    asadmin_exec(["list-system-properties"]).each do |line|
      if line.match(/^[^=]+=/)
        key, value = line.split("=")
        return true if @resource[:name] == key
      end
    end
    return false
  end
end
