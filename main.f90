program main
  use nvtx
  character(len=4) :: itcount

  ! First range with standard color
  call nvtxStartRange("First label")

  do n=1,14
    ! Create custom label for each marker
    write(itcount,'(i4)') n

    ! Range with custom  color
    call nvtxStartRange("Label "//itcount,n)

    print *,"Generate label",n
    ! Add sleep to make markers big 
    call sleep(1)

    call nvtxEndRange
  end do

  call nvtxEndRange
end program main
