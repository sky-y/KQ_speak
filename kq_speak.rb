#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# Programming Language KQ
# with modification to speak

# original source by @nvsofts http://ideone.com/DDWfy
# twitter: http://ideone.com/DDWfy

require 'moji'

input_org = STDIN.readlines.join.chomp
input = input_org.force_encoding('UTF-8').tr('^ﾀﾞｧｼｴﾘｲｪｽ', '')

## say

da = Moji.han_to_zen(input_org).split(/[\r\n]/).join("").split("！")
#da = Moji.han_to_zen(input_org).split(/[\r\n]/).join("")
#puts da
#command = 'SayKana -s 170 -o da.aiff' + da
da.each do |l| 
	next if l == ""
	l += "！"
	puts Moji.zen_to_han(l)
	command = 'SayKana -s 170 ' + l
	system(command)
end


## put

if input.length % 6 != 0 then
  puts "プログラムが不正です"
  exit(1)
end

buffer = Array.new(32768, 0)
ptr = 0
run_ptr = 0

while run_ptr != input.length
  case input[run_ptr, 6]
  when 'ﾀﾞｧｲｪｽ' # >
    ptr += 1
  when 'ｲｪｽﾀﾞｧ' # <
    ptr -= 1
  when 'ﾀﾞｧﾀﾞｧ' # +
    buffer[ptr] += 1
  when 'ｼｴﾘｼｴﾘ' # -
    buffer[ptr] -= 1
  when 'ﾀﾞｧｼｴﾘ' # ,
    buffer[ptr] = STDIN.getc
  when 'ｼｴﾘﾀﾞｧ' # .
    print buffer[ptr].chr
  when 'ｼｴﾘｲｪｽ' # [
    if buffer[ptr] == 0 then
      nest = 1
      while nest != 0
        run_ptr += 6
        case input[run_ptr, 6]
        when 'ｼｴﾘｲｪｽ'
          nest += 1
        when 'ｲｪｽｼｴﾘ'
          nest -= 1
        end
      end
    end
  when 'ｲｪｽｼｴﾘ' # ]
    if buffer[ptr] != 0 then
      nest = 1
      while nest != 0
        run_ptr -= 6
        case input[run_ptr, 6]
        when 'ｼｴﾘｲｪｽ'
          nest -= 1
        when 'ｲｪｽｼｴﾘ'
          nest += 1
        end
      end
      run_ptr -= 6
    end
  end
  run_ptr += 6
end


