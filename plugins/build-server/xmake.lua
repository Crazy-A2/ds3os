task("build-server")
    set_category("plugin")
    on_run(function ()
        local helpers = import("common.build_helpers", {rootdir = path.join(os.projectdir(), "plugins")})

        local ctx = helpers.load_context()
        local xmake = helpers.find_xmake()
        if is_host("windows") then
            ctx.plat = helpers.ensure_windows_msvc_config(xmake, ctx.arch, ctx.mode)
        end

        local outputdir = helpers.ensure_outputdir(helpers.outputdir(ctx.arch, ctx.mode))
        helpers.build_target(xmake, "Server")

        if ctx.plat == "windows" and ctx.arch == "x64" then
            local dotnet = helpers.find_dotnet()
            helpers.build_target(xmake, "Injector")
            helpers.build_loader(dotnet, ctx.mode, outputdir)
        end

        helpers.organize_build_outputs(ctx.plat, outputdir)

        print("Server build complete: %s", outputdir)
    end)
    set_menu {
        usage = "xmake build-server [options]",
        description = "Build the Server target and copy runtime assets and lib dynamic libraries",
        options = {}
    }
