!ABCIncludeFile

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


 OMIT('_EndOfInclude_',_JSListMarkPresent_)

_JSListMarkPresent_ EQUATE(1)

                    ITEMIZE,PRE(TagFunc)
TagAll                  EQUATE(1)
UntagAll                EQUATE
FlipAll                 EQUATE
                    END

                    ITEMIZE,PRE(TagBehavior)
WrapBottom              EQUATE(1) !When scrolling down, wrap bottom to top
WrapTop                 EQUATE    !When scrolling up, wrap top to bottom
                    END

JS_ListMark         CLASS,TYPE,MODULE('JS_ListMark.clw'),LINK('JS_ListMark.clw',_ABCLinkMode_),DLL(_ABCDllMode_)
FirstChoice             LONG
LastChoice              LONG
AnchorChoice            LONG
PreAlertChoice          LONG !To fix a timing issue
Q                       &QUEUE
Mark                    ANY
ListFEQ                 LONG
Behavior                LONG !2018.12.03 - Bitswitch
EventsRegistered        LONG !Are the events currently registered?
Construct               PROCEDURE
Destruct                PROCEDURE,VIRTUAL
GetMarkCount            PROCEDURE(LONG pMarked=TRUE),LONG
Init                    PROCEDURE(LONG pListFEQ,*QUEUE pQ,*? pMark,LONG pBehavior=1)
RegisterEvents          PROCEDURE
RegisterHandler         PROCEDURE,BYTE !Used for REGISTER()
TakeEvent               PROCEDURE(LONG pEvent),LONG,PROC,VIRTUAL
TakeHotKey              PROCEDURE(LONG pHotKey)
TagProc                 PROCEDURE(LONG pType)
UnRegisterEvents        PROCEDURE
                    END          

  _EndOfInclude_


