---@field public isLinux int Check for Linux operating system 1 | 0 
---@field public isWindows int Check for Windows operating system 1 | 0 
---@field public isOSX int Check for Mac operating system 1 | 0 
local System = {}

local has = vim.fn.has
local fn = vim.fn
local vim_options = vim.o

if has('win16') == 1 or has('win32') == 1 or has('win64') == 1 then
  System.isWindows = 1
else
  System.isWindows = 0
end

if has('unix') == 1 and has('macunix') == 0 and has('win32unix') == 0 then
  System.isLinux = 1
else
  System.isLinux = 0
end

System.isOSX = has('macunix')

function System.name()
  if System.isLinux == 1 then
    return 'linux'
  elseif System.isWindows == 1 then
    if has('win32unix') == 1 then
      return 'cygwin'
    else
      return 'windows'
    end
  else
    return 'mac'
  end
end

local is_darwin = nil
function System.isDarwin()
  if is_darwin ~= nil then
    return is_darwin
  end
  if has('macunix') == 1 then
    is_darwin = 1
    return is_darwin
  end
  if has('unix') ~= 1 then
    is_darwin = 0
    return is_darwin
  end
  if fn.system('uname -s') == "Darwin\n" then
    is_darwin = 1
  else
    is_darwin = 0
  end
  return is_darwin
end

function System.fileformat()
  local fileformat = ''
  if vim_options.fileformat == 'dos' then
    fileformat = ''
  elseif vim_options.fileformat == 'unix' then
    if System.isDarwin() == 1 then
      fileformat = ''
    else
      fileformat = ''
    end
  elseif vim_options.fileformat == 'mac' then
    fileformat = ''
  end
  return fileformat
end

return System
