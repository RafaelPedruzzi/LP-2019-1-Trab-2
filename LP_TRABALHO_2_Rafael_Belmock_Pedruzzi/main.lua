--[[
Linguagens de Programação - Prof. Flavio Varejão - 2019-1
Segundo trabalho de implementação

Aluno: Rafael Belmock Pedruzzi

main.lua: módulo main
--]]

local point = require("point")
local trabIO = require("trabIO")

-- Obtendo a distância mínima e a lista de pontos dos arquivos de entrada
dist, p = trabIO.readEntry()

-- Realizando oo algoritimo de agrupamento
g = point.makeGroups(dist, p)

-- Calculando o SSE do agrupamento
sse = point.sse(g)

-- Imprimindo arquivos de saida
trabIO.writeSSE(sse)
trabIO.writeGroups(g)
