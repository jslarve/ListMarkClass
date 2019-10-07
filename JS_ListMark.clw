    MEMBER

! * Created with Clarion 10.0
! * User: Jeff Slarve
! * Date: 7/21/2018
! * Time: 10:22 AM

!MIT License
!
!Copyright (c) 2019 Jeff Slarve
!
!Permission is hereby granted, free of charge, to any person obtaining a copy
!of this software and associated documentation files (the "Software"), to deal
!in the Software without restriction, including without limitation the rights
!to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
!copies of the Software, and to permit persons to whom the Software is
!furnished to do so, subject to the following conditions:
!
!The above copyright notice and this permission notice shall be included in all
!copies or substantial portions of the Software.
!
!THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
!IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
!FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
!AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
!LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
!OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
!SOFTWARE.


    INCLUDE('JS_ListMark.inc'),ONCE
    INCLUDE('KEYCODES.CLW'),ONCE
  
    MAP
    END

!======================================================================================================================================================
JS_ListMark.Construct PROCEDURE
!======================================================================================================================================================

    CODE

        SELF.AnchorChoice     =  0
        SELF.FirstChoice      =  0
        SELF.LastChoice       =  0
        SELF.Behavior         =  TagBehavior:WrapTop+TagBehavior:WrapBottom
        SELF.EventsRegistered =  FALSE        

!======================================================================================================================================================
JS_ListMark.Destruct  PROCEDURE
!======================================================================================================================================================

    CODE
        
        SELF.Mark &= NULL

!======================================================================================================================================================
JS_ListMark.GetMarkCount    PROCEDURE(LONG pMarked=TRUE)!,LONG
!======================================================================================================================================================
MarkCount                       LONG,AUTO
Ndx                             LONG,AUTO

    CODE
        
        MarkCount = 0
        LOOP Ndx = 1 TO RECORDS(SELF.Q)
            GET(SELF.Q,Ndx)
            IF ERRORCODE()
                MarkCount = -1 !There was a problem of some kind that should never happen
                BREAK
            END
            IF pMarked
                IF SELF.Mark
                    MarkCount += 1 !Getting the marked count
                END
            ELSE
                IF NOT SELF.Mark
                    MarkCount += 1 !Getting the un-marked count
                END
            END
        END
        RETURN MarkCount
        
!======================================================================================================================================================
JS_ListMark.Init   PROCEDURE(LONG pListFEQ,*QUEUE pQ,*? pMark,LONG pBehavior=1)
!======================================================================================================================================================

   CODE

        IF pListFEQ{PROP:Type} <> Create:List
            MESSAGE('Error in JS_ListMark.Init():|| You need to pass the FEQ of a Clarion List control as the first parameter.','Error',ICON:Exclamation)
            RETURN
        END
        SELF.ListFEQ                =  pListFEQ !Assign the listbox
        SELF.Q                     &=  pQ       !Assign the queue from the listbox
        SELF.Mark                  &=  pMark    !Assign which field in the queue is to be used for marking.

        SELF.ListFEQ{PROP:Alrt,255} =  MouseLeft
        SELF.ListFEQ{PROP:Alrt,255} =  MouseLeft2
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlMouseLeft
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftMouseLeft
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlEnd
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlHome
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftEnd
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftHome
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlShiftHome
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlShiftEnd        
        SELF.ListFEQ{PROP:Alrt,255} =  HomeKey
        SELF.ListFEQ{PROP:Alrt,255} =  EndKey
        SELF.ListFEQ{PROP:Alrt,255} =  UpKey
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftUp
        SELF.ListFEQ{PROP:Alrt,255} =  DownKey
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftDown
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftPgUp
        SELF.ListFEQ{PROP:Alrt,255} =  ShiftPgDn
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlA
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlU
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlF
        SELF.ListFEQ{PROP:Alrt,255} =  CtrlMouseRight

        IF BAND(pBehavior,1)              !Mark currently selected row  
            SELF.TagProc(TagFunc:UntagAll) !Untag everything else
            GET(SELF.Q,Choose(CHOICE(SELF.ListFEQ)<>0,CHOICE(SELF.ListFEQ),1))
            IF NOT ERRORCODE()
                SELF.AnchorChoice =  POINTER(SELF.Q)
                SELF.Mark         =  TRUE
                PUT(SELF.Q)
            END
         END

        SELF.RegisterEvents

!======================================================================================================================================================
JS_ListMark.RegisterEvents  PROCEDURE
!======================================================================================================================================================

    CODE

        IF SELF.EventsRegistered
            RETURN
        END
        
        REGISTER(EVENT:PreAlertKey, ADDRESS(SELF.RegisterHandler),ADDRESS(SELF),,SELF.ListFEQ)
        REGISTER(EVENT:AlertKey,    ADDRESS(SELF.RegisterHandler),ADDRESS(SELF),,SELF.ListFEQ)
        REGISTER(EVENT:CloseWindow, ADDRESS(SELF.RegisterHandler),ADDRESS(SELF))
        SELF.EventsRegistered = TRUE
        
!======================================================================================================================================================
JS_ListMark.RegisterHandler    PROCEDURE !,BYTE !Used for REGISTER()
!======================================================================================================================================================

    CODE
     
        RETURN CHOOSE(SELF.TakeEvent(EVENT())=1,Level:Notify,Level:Benign)
        
!======================================================================================================================================================
JS_ListMark.TakeEvent  PROCEDURE(SIGNED pEvent)
!======================================================================================================================================================

    CODE

        IF pEvent = EVENT:CloseWindow
            SELF.UnRegisterEvents
        END
        
        IF FIELD() <> SELF.ListFEQ
            RETURN 0
        END

        CASE pEvent
        OF EVENT:PreAlertKey
            CASE KEYCODE()
            OF MouseLeft
            OROF CtrlMouseLeft
            OROF ShiftMouseLeft
            OROF HomeKey
            OROF EndKey
            OROF CtrlEnd
            OROF CtrlHome
            OROF ShiftHome
            OROF ShiftEnd
            OROF CtrlShiftHome
            OROF CtrlShiftEnd
            OROF UpKey
            OROF ShiftUp
            OROF DownKey
            OROF ShiftDown
            OROF ShiftPgUp
            OROF ShiftPgDn
            OROF CtrlA
            OROF CtrlU
            OROF CtrlF
              SELF.PreAlertChoice = Choice(SELF.ListFEQ)
              RETURN 1
            END
        OF EVENT:AlertKey
            SELF.TakeHotKey(KeyCode())
        END
        
        RETURN 0

!======================================================================================================================================================
JS_ListMark.TagProc     PROCEDURE(LONG pType)
!======================================================================================================================================================
Y                       LONG,AUTO

    CODE
        
        LOOP Y = 1 TO RECORDS(SELF.Q)
            GET(SELF.Q,Y)
            IF ERRORCODE() !This would be unexpected
                BREAK
            END
            CASE pType
            OF TagFunc:TagAll
                SELF.Mark = TRUE
            OF TagFunc:UntagAll
                SELF.Mark = FALSE
            OF TagFunc:FlipAll
                SELF.Mark = CHOOSE(NOT SELF.Mark)
            END
            PUT(SELF.Q)
            IF ERRORCODE() !This would be unexpected
                BREAK
            END
        END
        
!======================================================================================================================================================
JS_ListMark.TakeHotKey  PROCEDURE(LONG pHotKey)
!======================================================================================================================================================
Direction               LONG,AUTO
NewRow                  LONG,AUTO
Y                       LONG,AUTO

    CODE
     
    CASE pHotKey !Doing a small CASE statement with an ELSE here because it seemed easiest.
    OF ShiftMouseLeft OROF ShiftUp OROF ShiftDown OROF ShiftHome OROF ShiftEnd OROF ShiftPgUp OROF ShiftPgDn OROF CtrlShiftHome OROF CtrlShiftEnd
    ELSE
      SELF.AnchorChoice = CHOICE(SELF.ListFEQ) 
      SELF.LastChoice   = 0
    END

    CASE pHotKey
    OF CtrlA
        SELF.TagProc(TagFunc:TagAll)
        SELF.AnchorChoice =  1 !This behavior could use some looking at
        SELF.LastChoice   =  RECORDS(SELF.Q)
    OF CtrlU
        SELF.TagProc(TagFunc:UnTagAll)
        SELF.AnchorChoice = 0
        SELF.LastChoice   =  0
    OF CtrlF
        SELF.TagProc(TagFunc:FlipAll)
    OF MouseLeft 
        SELF.TagProc(TagFunc:UntagAll)
        GET(SELF.Q,INT(SELF.ListFEQ{PROPLIST:MouseDownRow}))
        SELF.Mark = TRUE
        PUT(SELF.Q)
        SELF.LastChoice = POINTER(SELF.Q)
    OF CtrlHome OROF HomeKey 
        SELF.TagProc(TagFunc:UntagAll)
        GET(SELF.Q,1)
        SELF.Mark = TRUE
        PUT(SELF.Q)
        SELF.AnchorChoice = 1
        SELF.ListFEQ{PROP:Selected} = 1
    OF CtrlEnd OROF EndKey
        SELF.TagProc(TagFunc:UntagAll)
        GET(SELF.Q,RECORDS(SELF.Q))
        SELF.Mark = TRUE
        PUT(SELF.Q)
        SELF.AnchorChoice = RECORDS(SELF.Q)
    OF UpKey OROF DownKey
        CASE SELF.PreAlertChoice!CHOICE(SELF.ListFEQ)
        OF 1
            IF BAND(SELF.Behavior,TagBehavior:WrapBottom)
                IF pHotKey = UpKey
                    SELF.ListFEQ{PROP:Selected} =  RECORDS(SELF.Q)
                    SELF.AnchorChoice           =  RECORDS(SELF.Q)
                END
            END
        OF RECORDS(SELF.Q)
            IF BAND(SELF.Behavior,TagBehavior:WrapTop)
                IF pHotKey = DownKey
                    SELF.ListFEQ{PROP:Selected} = 1
                    SELF.AnchorChoice = 1
                END
            END
        ELSE
        END
        SELF.TagProc(TagFunc:UntagAll)
        GET(SELF.Q,CHOICE(SELF.ListFEQ))
        SELF.Mark = TRUE 
        PUT(SELF.Q)
    OF CtrlMouseLeft
      !Do Nothing, because it is how Clarion MARK works to begin with :)
    OF ShiftMouseLeft OROF ShiftUp OROF ShiftDown OROF ShiftHome OROF ShiftEnd OROF ShiftPgUp OROF ShiftPgDn OROF CtrlShiftEnd OROF CtrlShiftHome
        IF NOT SELF.AnchorChoice
            SELF.AnchorChoice = CHOICE(SELF.ListFEQ)
        END
        IF NOT SELF.LastChoice
            SELF.LastChoice = SELF.AnchorChoice
        END
        CASE pHotKey 
        OF ShiftMouseLeft      
            NewRow = SELF.ListFEQ{PROPList:MouseDownRow}
        OF ShiftHome 
            NewRow = 1
        OF ShiftEnd
            NewRow = RECORDS(SELF.Q)       
        ELSE
            NewRow = CHOICE(SELF.ListFEQ)
        END
        IF NewRow > SELF.LastChoice
            Direction = 1
        ELSIF NewRow < SELF.LastChoice
            Direction = -1
        ELSE
           SELF.TagProc(TagFunc:UntagAll)
           GET(SELF.Q,NewRow)
           SELF.Mark = TRUE
           PUT(SELF.Q)
           RETURN 
        END
        SELF.TagProc(TagFunc:UntagAll)
        LOOP Y = SELF.LastChoice TO NewRow BY Direction
            GET(SELF.Q,Y)
            SELF.Mark = TRUE
            PUT(SELF.Q)
        END
    OF CtrlMouseRight
        SELECT(SELF.ListFEQ)
    END
    CASE pHotKey !Again, this seemed easiest.
    OF MouseLeft
    OROF CtrlMouseLeft
    OROF ShiftMouseLeft
    OROF HomeKey
    OROF EndKey
    OROF CtrlEnd
    OROF CtrlHome
    OROF ShiftHome
    OROF ShiftEnd
    OROF CtrlShiftHome
    OROF CtrlShiftEnd
    OROF UpKey
    OROF ShiftUp
    OROF DownKey
    OROF ShiftDown
    OROF ShiftPgUp
    OROF ShiftPgDn
    OROF CtrlA
    OROF CtrlU
    OROF CtrlF
        POST(EVENT:NewSelection,SELF.ListFEQ)
    END
        
!======================================================================================================================================================
JS_ListMark.UnRegisterEvents        PROCEDURE
!======================================================================================================================================================

    CODE
       
        IF NOT SELF.EventsRegistered
            RETURN
        END
        
        UNREGISTER(EVENT:PreAlertKey, ADDRESS(SELF.RegisterHandler),ADDRESS(SELF),,SELF.ListFEQ)
        UNREGISTER(EVENT:AlertKey,    ADDRESS(SELF.RegisterHandler),ADDRESS(SELF),,SELF.ListFEQ)
        UNREGISTER(EVENT:CloseWindow, ADDRESS(SELF.RegisterHandler),ADDRESS(SELF))
        SELF.EventsRegistered = FALSE        
        
        