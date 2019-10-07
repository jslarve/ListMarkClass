
                    PROGRAM

    INCLUDE('JS_ListMark.inc')
    INCLUDE('KEYCODES.CLW')

OMIT('***')
 * Created with Clarion 10.0
 * User: Jeff Slarve
 * Date: 10/2/2019
 * Time: 11:08 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 ***


                    MAP
                    END

Q                   QUEUE
Column1                 STRING(20)
Column2                 STRING(20)
Mark                    BYTE
                    END


ListMarker          JS_ListMark

MarkCount           LONG
GenerationQty       LONG(3000)

Window              WINDOW('JS_ListMark Class Demo'),AT(,,395,224),CENTER,GRAY,SYSTEM, |
                        FONT('Microsoft Sans Serif',10),DOUBLE
                        LIST,AT(5,4,179,205),USE(?LIST1),VSCROLL,MARK(Q.Mark),FROM(Q), |
                            FORMAT('81L(2)|M~Column 1~C(0)81L(2)|M~Column 2~C(0)')
                        STRING('0 of 0'),AT(28,212,152),USE(?CountString),RIGHT
                        PROMPT('Use the standard hotkeys to mark various records in the listbox.' & |
                            ' (Click, Ctrl+Click, Shift+Click, Ctrl+A, Ctrl+U, Ctrl+F, etc..' & |
                            ')<10,10>This class uses the built-in Clarion MARK attribute for' & |
                            ' marking listboxes, but adds missing hotkey functionality.'), |
                            AT(194,5,192,46),USE(?PROMPT1)
                        PROMPT('Rows to Generate:'),AT(194,112),USE(?PROMPT2)
                        SPIN(@n12),AT(254,111,34),USE(GenerationQty),RIGHT,STEP(500)
                        BUTTON('Generate Random Data'),AT(291,110,84),USE(?GenerateButton)
                        BUTTON('Mark &All (Ctrl+A)'),AT(197,138,72),USE(?MarkAllButton)
                        BUTTON('&Un-Mark All (Ctrl+U)'),AT(197,154,72,14),USE(?UnMarkAllButton)
                        BUTTON('&Flip All (Ctrl+F)'),AT(197,170,72,14),USE(?FlipAllButton)
                        BUTTON('Cl&ose'),AT(348,206,42,14),USE(?CloseButton),STD(STD:Close)
                        PROMPT('NOTE: The Mark attribute only works for listboxes up to 65536 re' & |
                            'cords. The marking works after that, but you can''t see it when' & |
                            ' setting the MARK field programmatically on the subsequent records.'), |
                            AT(194,50,192,38),USE(?PROMPT3),FONT(,,,FONT:bold)
                    END

  CODE

        
        OPEN(Window)
        DO GenerateData
        ListMarker.Init(?LIST1,Q,Q.Mark)
        ListMarker.Behavior = 0
        ListMarker.TakeHotKey(HomeKey)
        DO DisplayInfo
        ACCEPT
            CASE ACCEPTED()
            OF ?GenerateButton
                DO GenerateData
                ListMarker.TakeHotKey(HomeKey)
            OF ?MarkAllButton
                ListMarker.TakeHotKey(CtrlA)
                SELECT(?LIST1)
            OF ?UnMarkAllButton
                ListMarker.TakeHotKey(CtrlU)
                SELECT(?LIST1)
            OF ?FlipAllButton
                ListMarker.TakeHotKey(CtrlF)
                SELECT(?LIST1)
            END
            CASE ACCEPTED()
            OF ?GenerateButton OROF ?MarkAllButton OROF ?UnMarkAllButton OROF ?FlipAllButton
                DO DisplayInfo
            END
            CASE FIELD()
            OF ?LIST1
                CASE EVENT()
                OF EVENT:NewSelection
                    DO DisplayInfo
                END
            END
            
        END
        
        
GenerateData        ROUTINE
    
    FREE(Q)
    LOOP GenerationQty TIMES !Generate some random data
        Q.Column1 = CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90))
        Q.Column2 = CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90)) & CHR(RANDOM(65,90))
        Q.Mark    = 0
        ADD(Q)
    END
    SELECT(?LIST1,1)
        
DisplayInfo      ROUTINE
    
    MarkCount               =  ListMarker.GetMarkCount() 
    ?CountString{PROP:Text} =  MarkCount & ' of ' & RECORDS(Q) 
