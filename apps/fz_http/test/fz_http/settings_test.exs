defmodule FzHttp.SettingsTest do
  use FzHttp.DataCase

  alias FzHttp.Settings

  @setting_keys ~w(
    default.device.dns_servers
    default.device.allowed_ips
    default.device.endpoint
  )

  describe "settings" do
    alias FzHttp.Settings.Setting

    import FzHttp.SettingsFixtures

    @valid_settings %{
      "default.device.dns_servers" => "8.8.8.8",
      "default.device.allowed_ips" => "::/0",
      "default.device.endpoint" => "172.10.10.10"
    }
    @invalid_settings %{
      "default.device.dns_servers" => "foobar",
      "default.device.allowed_ips" => nil,
      "default.device.endpoint" => "foobar"
    }

    test "get_setting!/1 returns the setting with given id" do
      setting = setting_fixture()
      assert Settings.get_setting!(setting.id) == setting
    end

    test "get_setting!/1 returns the setting with the given key" do
      for key <- @setting_keys do
        setting = Settings.get_setting!(key: key)
        assert setting.key == key
      end
    end

    test "update_setting/2 with valid data updates the setting via provided setting" do
      for key <- @setting_keys do
        value = @valid_settings[key]
        setting = Settings.get_setting!(key: key)
        assert {:ok, %Setting{} = setting} = Settings.update_setting(setting, %{value: value})
        assert setting.key == key
        assert setting.value == value
      end
    end

    test "update_setting/2 with valid data updates the setting via key, value" do
      for key <- @setting_keys do
        value = @valid_settings[key]
        assert {:ok, %Setting{} = setting} = Settings.update_setting(key, value)
        assert setting.key == key
        assert setting.value == value
      end
    end

    test "update_setting/2 with invalid data returns error changeset" do
      for key <- @setting_keys do
        value = @invalid_settings[key]
        assert {:error, %Ecto.Changeset{}} = Settings.update_setting(key, value)
        setting = Settings.get_setting!(key: key)
        refute setting.value == value
      end
    end

    test "change_setting/1 returns a setting changeset" do
      setting = setting_fixture()
      assert %Ecto.Changeset{} = Settings.change_setting(setting)
    end
  end
end
