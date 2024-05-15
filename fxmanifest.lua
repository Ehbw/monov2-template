fx_version 'cerulean'
games {'gta5', 'rdr3', 'gta4'}

author 'Ehbw'
description 'Mono V2 Template'
repository 'https://github.com/Ehbw/mono-rt2-template'
version '0.0.1'

mono_rt2 "Prerelease expiring 2024-06-30. See https://aka.cfx.re/mono-rt2-preview for info."
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

client_script 'dist/client/**.dll'
server_script 'dist/server/**.dll'