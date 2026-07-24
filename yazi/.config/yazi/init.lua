require("git"):setup()
require("starship"):setup({
	config_file = "~/.config/yazi/starship.toml",
})

function Linemode:size_and_mtime()
    -- 获取文件的修改时间戳，如果没有则设为 0
    local time = math.floor(self._file.cha.mtime or 0)
    if time == 0 then
        time = ""
    -- 如果是今年修改的文件，显示 "月 日 时:分"
    elseif os.date("%Y", time) == os.date("%Y") then
        time = os.date("%b %d %H:%M", time)
    -- 否则显示 "月 日 年"
    else
        time = os.date("%b %d %Y", time)
    end
    -- 获取文件大小并格式化为人类可读的形式
    local size = self._file:size()
    -- 返回格式化后的字符串，例如 "12.3K Jan 01 14:30"
    return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end
