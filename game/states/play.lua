local Note = require "game.note"
local StrumNote = require "game.strumnote"
local Group = require "game.group"

local play = {
    song = {
        song = "",
        notes = {},
        bpm = 0,
        needsVoice = true,
        speed = 1,
        player1 = "",
        player2 = ""
    }
}

local vocals

local opponentStrums
local playerStrums

local unspawnNotes

local function newStrumGroup(player)
    local group = Group()
    _c.add(group)
    for i = 1, 4, 1 do
        group:add(StrumNote(42, 40, i - 1, player):postAddedToGroup())
    end
    return group
end

function play.enter()
    local song = "bopeebo"
    play.song = paths.parseJson(song .. "/" .. song).song
    -- vocals = paths.music(song .. "/Voices")

    unspawnNotes = {}

    for _, s in ipairs(play.song.notes) do
        for a, n in ipairs(s.sectionNotes) do
            local length = #unspawnNotes
            local daNoteData = n[2] % 4
            local gottaHitNote = s.mustHitSection

            if n[2] > 3 then gottaHitNote = not gottaHitNote end

            local oldNote
            if length > 0 then
                oldNote = unspawnNotes[length - 1]
            else
                oldNote = nil
            end
            length = length + 1

            local swagNote = Note(n[1], daNoteData, oldNote)
            swagNote.sustainLength = n[3]
            table.insert(unspawnNotes, swagNote)

            local susLength = n[3] / music.period
            if susLength > 0 then
                for susNote = 1, math.floor(susLength) do
                    oldNote = unspawnNotes[length - 1]

                    local sustainNote = Note(
                                            n[1] + music.period * (susNote + 1),
                                            daNoteData, oldNote, true)
                    sustainNote.mustPress = gottaHitNote
                    table.insert(unspawnNotes, sustainNote)
                end
            end
        end
    end

    opponentStrums = newStrumGroup(0)
    playerStrums = newStrumGroup(1)
end

function play.update(dt)
    playerStrums:call("update", dt)
    opponentStrums:call("update", dt)
    for i, s in ipairs(playerStrums.members) do
        if input:down(Note.directions[i]) then
            s:play("confirm")
        else
            s:play("static")
        end
    end
end

function play.draw()
    playerStrums:call("draw")
    opponentStrums:call("draw")
end

return play
