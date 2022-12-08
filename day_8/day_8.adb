with Ada.Text_IO; use Ada.Text_IO;
with Ada.Containers.Vectors;

procedure Day_8 is
   package Integer_Vectors is new
   Ada.Containers.Vectors
      (Index_Type => Natural,
      Element_Type => Integer);
   use Integer_Vectors;

   package Integer_Matrices is new
   Ada.Containers.Vectors
      (Index_Type => Natural,
      Element_Type => Integer_Vectors.Vector);

   function Is_Visible (Heights : Integer_Matrices.Vector; Line : Natural; Col : Natural)
   return Boolean is
      Visible : Boolean := True;
   begin
      for I in Heights.First_Index .. Line - 1 loop
         if Heights (I)(Col) >= Heights (Line)(Col) then
            Visible := False;
            exit;
         end if;
      end loop;

      if not Visible then
         Visible := True;
         for I in Line + 1 .. Heights.Last_Index loop
            if Heights (I)(Col) >= Heights (Line)(Col) then
               Visible := False;
               exit;
            end if;
         end loop;
      end if;

      if not Visible then
         Visible := True;
         for I in Heights (Line).First_Index .. Col - 1 loop
            if Heights (Line)(I) >= Heights (Line)(Col) then
               Visible := False;
               exit;
            end if;
         end loop;
      end if;

      if not Visible then
         Visible := True;
         for I in Col + 1 .. Heights (Line).Last_Index loop
            if Heights (Line)(I) >= Heights (Line)(Col) then
               Visible := False;
               exit;
            end if;
         end loop;
      end if;

      return Visible;
   end Is_Visible;

   function Part_One (Heights: Integer_Matrices.Vector) return Integer is
      Nb_Visible : Integer := 0;
   begin
      for I in Heights.First_Index .. Heights.Last_Index loop
         for J in Heights (I).First_Index .. Heights (I).Last_Index loop
            if Is_Visible (Heights, I, J) then
               Nb_Visible := Nb_Visible + 1;
            end if;
         end loop;
      end loop;

      return Nb_Visible;
   end Part_One;

   function Get_Scenic_Score (Heights : Integer_Matrices.Vector; Line : Natural; Col : Natural)
   return Integer is
      Top_Score : Integer := 0;
      Bottom_Score : Integer := 0;
      Left_Score : Integer := 0;
      Right_Score : Integer := 0;
   begin
      for I in reverse Heights.First_Index .. Line - 1 loop
         Top_Score := Top_Score + 1;
         exit when Heights (I)(Col) >= Heights (Line)(Col);
      end loop;

      for I in Line + 1 .. Heights.Last_Index loop
         Bottom_Score := Bottom_Score + 1;
         exit when Heights (I)(Col) >= Heights (Line)(Col);
      end loop;

      for I in reverse Heights (Line).First_Index .. Col - 1 loop
         Left_Score := Left_Score + 1;
         exit when Heights (Line)(I) >= Heights (Line)(Col);
      end loop;

      for I in Col + 1 .. Heights (Line).Last_Index loop
         Right_Score := Right_Score + 1;
         exit when Heights (Line)(I) >= Heights (Line)(Col);
      end loop;

      return Top_Score * Bottom_Score * Left_Score * Right_Score;
   end Get_Scenic_Score;

   function Part_Two (Heights: Integer_Matrices.Vector) return Integer is
      Max_Score : Integer := 0;
   begin
      for I in Heights.First_Index .. Heights.Last_Index loop
         for J in Heights (I).First_Index .. Heights (I).Last_Index loop
            Max_Score := Integer'Max (Max_Score, Get_Scenic_Score (Heights, I, J));
         end loop;
      end loop;

      return Max_Score;
   end Part_Two;

   File : constant String := "input.txt";
   Input : File_type;
   Heights : Integer_Matrices.Vector;
begin
   Open (Input, In_File, File);
   while not End_Of_File (Input) loop
      declare
         Line : String := Get_Line (Input);
         Line_Heights : Integer_Vectors.Vector;
      begin
         for  I in Line'Range loop
            Line_Heights.Append (Character'Pos (Line (I)) - Character'Pos ('0'));
         end loop;
         Heights.Append (Line_Heights);
      end;
   end loop;
   Close (Input);

   Put_Line ("part one:" & Integer'Image (Part_One (Heights)));
   Put_Line ("part two:" & Integer'Image (Part_Two (Heights)));
end Day_8;
