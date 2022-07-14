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

-- local vocals

local opponentStrums
local playerStrums

local unspawnNotes
local notes

local noteStuff = {image = nil, xmlData = nil}

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
    _c.add(unspawnNotes)
    notes = {}
    _c.add(notes)

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

            -- local swagNote = Note(n[1], daNoteData, oldNote)
            -- swagNote.mustPress = gottaHitNote
            -- table.insert(unspawnNotes, swagNote)
            table.insert(unspawnNotes, {
                strumTime = n[1],
                noteData = daNoteData,
                prevNote = oldNote,
                isSustainNote = false,
                mustPress = gottaHitNote
            })

            local susLength = n[3] / music.period
            if susLength > 0 then
                for susNote = 1, math.floor(susLength) do
                    oldNote = unspawnNotes[length - 1]

                    -- local sustainNote = Note(
                    --                         n[1] + music.period * (susNote + 1),
                    --                         daNoteData, oldNote, true)
                    -- sustainNote.mustPress = gottaHitNote
                    -- table.insert(unspawnNotes, sustainNote)
                    table.insert(unspawnNotes, {
                        strumTime = n[1] + music.period * (susNote + 1),
                        noteData = daNoteData,
                        prevNote = oldNote,
                        isSustainNote = true,
                        mustPress = gottaHitNote
                    })
                end
            end
        end
    end

    opponentStrums = newStrumGroup(0)
    playerStrums = newStrumGroup(1)
end

function play.update(dt)
    local time = music:getTime() + 1000
    local oldNote
    for i, n in ipairs(unspawnNotes) do
        local length = #notes
        if length < i and n.strumTime <= time then
            if length > 0 then
                oldNote = notes[length + 1]
            else
                oldNote = nil
            end

            local gotStuff = noteStuff.image ~= nil and noteStuff.xmlData ~= nil

            local daNote = Note(n.strumTime, n.noteData, oldNote,
                                n.isSustainNote, not gotStuff)
            if gotStuff then
                daNote.image = noteStuff.image
                daNote.xmlData = noteStuff.xmlData
                daNote:loadStuff()
            else
                noteStuff.image = daNote.image
                noteStuff.xmlData = daNote.xmlData
            end
            daNote.mustPress = n.mustPress
            table.insert(notes, daNote)

            print(daNote.curName)

            table.remove(unspawnNotes, i)
        end
    end

    playerStrums:call("update", dt)
    opponentStrums:call("update", dt)
    for i, s in ipairs(playerStrums.members) do
        if input:down(Note.directions[i]) then
            s:play("confirm")
        else
            s:play("static")
        end
    end

    for _, n in ipairs(notes) do
        local strum =
            (n.mustPress and playerStrums or opponentStrums).members[n.noteData +
                1]
        n.x = strum.x
        n.y = 40 - (time - n.strumTime) * (0.45 * play.song.speed)
        n:update(dt)
    end
end

function play.draw()
    playerStrums:call("draw")
    opponentStrums:call("draw")

    for _, n in ipairs(notes) do n:draw() end
end

return play
