module nvtx

use iso_c_binding
implicit none

integer,private :: col(7) = [ Z'0000ff00', Z'000000ff', Z'00ffff00', &
Z'00ff00ff', Z'0000ffff', Z'00ff0000', Z'00ffffff']
character, private, target :: tempName(256)


type, bind(C):: nvtxEventAttributes
  integer(C_INT16_T):: version=1
  integer(C_INT16_T):: size=48 !
  integer(C_INT):: category=0
  integer(C_INT):: colorType=1 ! NVTX_COLOR_ARGB = 1
  integer(C_INT):: color
  integer(C_INT):: payloadType=0 ! NVTX_PAYLOAD_UNKNOWN = 0
  integer(C_INT):: reserved0
  integer(C_INT64_T):: payload   ! union uint,int,double
  integer(C_INT):: messageType=1  ! NVTX_MESSAGE_TYPE_ASCII     = 1 
  type(C_PTR):: message  ! ascii char
end type

interface nvtxRangePush
  ! push range with custom label and standard color
  subroutine nvtxRangePushA(name) bind(C, name='nvtxRangePushA')
  use iso_c_binding
  character(kind=C_CHAR) :: name(256)
  end subroutine

  ! push range with custom label and custom color
  subroutine nvtxRangePushEx(event) bind(C, name='nvtxRangePushEx')
  use iso_c_binding
  import:: nvtxEventAttributes
  type(nvtxEventAttributes):: event
  end subroutine
end interface

interface nvtxRangePop
  subroutine nvtxRangePop() bind(C, name='nvtxRangePop')
  end subroutine
end interface

interface nvtxRangeStart
   function nvtxRangeStartA(name) bind(C, name='nvtxRangeStartA')
     use iso_c_binding
     character(kind=C_CHAR) :: name(256)
     !integer(C_INT64_T), value :: nvtxRangeStartA ! value is ignored anway?
     integer(C_INT64_T) :: nvtxRangeStartA
   end function nvtxRangeStartA

   function nvtxRangeStartEx(event) bind(C, name='nvtxRangeStartEx')
     use iso_c_binding
     import:: nvtxEventAttributes
     type(nvtxEventAttributes):: event
     !integer(C_INT64_T), value :: nvtxRangeStartEx
     integer(C_INT64_T) :: nvtxRangeStartEx
   end function nvtxRangeStartEx
end interface

interface nvtxRangeEnd
   subroutine nvtxRangeEnd(id) bind(C, name='nvtxRangeEnd')
     use iso_c_binding
     integer(C_INT64_T),value :: id ! it is important that this be by value.
     ! c uses unsigned 64 bit int...should work as long as passed by value.
   end subroutine nvtxRangeEnd
end interface

contains

subroutine nvtxStartRange(name,color,id)
  character(kind=c_char,len=*) :: name
  integer, optional:: color ! integer determining the color
  integer(C_INT64_T), optional:: id ! returned unique id for the range
  type(nvtxEventAttributes):: event
  character(kind=c_char,len=256) :: trimmed_name
  integer :: i
  
  trimmed_name=trim(name)//c_null_char

  ! move scalar trimmed_name into character array tempName
  do i=1,LEN(trim(name)) + 1
     tempName(i) = trimmed_name(i:i)
  enddo


  if ( .not. present(id) ) then
     if ( .not. present(color)) then
        call nvtxRangePush(tempName)
     else
        event%color=col(mod(color,7)+1)
        event%message=c_loc(tempName)
        call nvtxRangePushEx(event)
     endif
  else
     if ( .not. present(color)) then
        id = nvtxRangeStartA(tempName)
     else
        event%color=col(mod(color,7)+1)
        event%message=c_loc(tempName)
        id = nvtxRangeStartEx(event)
     endif

  endif

end subroutine nvtxStartRange

subroutine nvtxEndRange(id)
  integer(C_INT64_T), optional:: id !id corresponding with nvtxStartRange
  if ( .not. present(id) ) then
     call nvtxRangePop
  else
     call nvtxRangeEnd(id)
  endif
end subroutine

end module nvtx
