#tag Module
Protected Module qoi
	#tag Method, Flags = &h0
		Function decode(mb As MemoryBlock, saveAsPNG As Boolean = False, fp As String = "") As Picture
		  Declare Function qoi_decode Lib qoiLib (data As Ptr, size As Integer, qoi_desc As Ptr, channels As Integer) As Ptr
		  // void *qoi_decode(const void *data, int size, qoi_desc *desc, int channels)
		  
		  Declare Function stbi_write_png Lib qoiLib (argv As Ptr, width As Integer, height As Integer, _
		  channels As Integer, pixels As Ptr, colorspace As Integer) As Integer
		  // int stbi_write_png(char const *filename, int x, int y, int comp, const void  *data, int stride_in_bytes);
		  
		  Dim desc, pixels As MemoryBlock
		  desc = New MemoryBlock(14)
		  
		  pixels = qoi_decode(mb, mb.Size, desc, 0)
		  Dim p As Picture
		  Dim rs As RGBSurface
		  Dim w, h, channels, colorspace, x, y, ix As Integer
		  
		  //desc.LittleEndian=False
		  w = desc.UInt32Value(0)
		  h = desc.UInt32Value(4)
		  channels = desc.UInt8Value(8)
		  colorspace = desc.UInt8Value(9)
		  
		  p = New Picture(w, h)
		  rs = p.RGBSurface
		  ix = 0
		  For y=0 To h-1
		    For x = 0 to w-1
		      Dim c As Color
		      If channels = 4 Then
		        c=Color.RGB(pixels.Uint8Value(ix), pixels.Uint8Value(ix+1), pixels.Uint8Value(ix+2), 255-pixels.Uint8Value(ix+3))
		        ix = ix + 4
		      Else
		        c=Color.RGB(pixels.Uint8Value(ix), pixels.Uint8Value(ix+1), pixels.Uint8Value(ix+2))
		        ix = ix + 3
		      End If
		      rs.Pixel(x, y) = c
		    Next
		  Next
		  
		  If saveAsPNG Then
		    Dim fpMB As MemoryBlock
		    fpMB=New MemoryBlock(fp.Length+1)
		    fpMB.CString(0)=fp
		    ix = stbi_write_png(fpMB, w, h, channels, pixels, 0)
		  End If
		  
		  Return p
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function decodeFile(fp As String) As Picture
		  Declare Function qoi_read Lib qoiLib (filename As Ptr, qoi_desc As Ptr, channels As Integer) As Ptr
		  // void *qoi_read(const char *filename, qoi_desc *desc, int channels) {
		  
		  Dim filename, desc, pixels As MemoryBlock
		  filename = fp
		  desc = New MemoryBlock(14)
		  
		  pixels = qoi_read(filename, desc, 0)
		  Dim p As Picture
		  Dim rs As RGBSurface
		  Dim w, h, channels, colorspace, x, y, ix As Integer
		  
		  //desc.LittleEndian=False
		  w = desc.UInt32Value(0)
		  h = desc.UInt32Value(4)
		  channels = desc.UInt8Value(8)
		  colorspace = desc.UInt8Value(9)
		  
		  p = New Picture(w, h)
		  rs = p.RGBSurface
		  ix = 0
		  For y=0 To h-1
		    For x = 0 to w-1
		      Dim c As Color
		      If channels = 4 Then
		        c=Color.RGB(pixels.Uint8Value(ix), pixels.Uint8Value(ix+1), pixels.Uint8Value(ix+2), pixels.Uint8Value(ix+3))
		        ix = ix + 4
		      Else
		        c=Color.RGB(pixels.Uint8Value(ix), pixels.Uint8Value(ix+1), pixels.Uint8Value(ix+2))
		        ix = ix + 3
		      End If
		      rs.Pixel(x, y) = c
		    Next
		  Next
		  
		  Return p
		End Function
	#tag EndMethod


	#tag Constant, Name = qoiLib, Type = String, Dynamic = False, Default = \"/usr/local/lib/qoi.dylib", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
