local M = {}

function M:peek(job)
    local start, cache = os.clock(), ya.file_cache(job)
    if not cache then
        return
    end

    local ok, err = self:preload(job)
    if not ok or err then
        return ya.preview_widget(job, err)
    end

    ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))

    local _, err = ya.image_show(cache, job.area)
    ya.preview_widget(job, err)
end

function M:seek() end

function M:preload(job)
    if not job then
        return true
    end

    local cache = ya.file_cache(job)
    if not cache or fs.cha(cache) then
        return true
    end

    local ext = tostring(job.file.url):match("%.([^.]+)$")
    if ext then
        ext = ext:lower()
    end

    local input_file = tostring(job.file.url)
    local needs_wrapper = ext ~= "scad"

    -- Build openscad command
    local colorscheme = job.args.colorscheme or "Cornfield"
    local img_width = 1000
    local img_height = 1000

    local cmd = Command("openscad"):arg {
        "--export-format", "png",
        "--colorscheme", colorscheme,
        "--imgsize", string.format("%d,%d", img_width, img_height),
        "-o", tostring(cache),
        needs_wrapper and "-" or input_file,
    }

    -- For non-scad files, pipe wrapper code via stdin
    if needs_wrapper then
        cmd = cmd:stdin(Command.PIPED)
    end

    local child, err = cmd:spawn()
    if not child then
        ya.err("Failed to start `openscad`, error: %s", err)
        return true
    end

    if needs_wrapper then
        local wrapper_code = string.format('import("%s");\n', input_file)
        child:write_all(wrapper_code)
        child:flush()
    end

    local status = child:wait()

    if not status then
        return true, Err("Error while running `openscad`: %s", err)
    elseif not status.success then
        return false, Err("`openscad` exited with error code: %s", status.code)
    else
        return true
    end
end

return M
