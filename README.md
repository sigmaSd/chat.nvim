# Chat.nvim

Nvim wrapper over chatgpt free web interface

Using https://github.com/sigmaSd/Chat

## Dependencies

Requires deno

## Usage

- add plugin: `sigmasd/chat.nvim`
- use ChatStart to start chat server
- then paste web.js contents https://github.com/sigmaSd/Chat/blob/master/web.js
  into chatgpt web console
- thats it now you use use Chat command to send input to chatgpt and receive an
  answer, if you have a selection in visual mode it will be sent with the
  provided input

## Demo

<img src="https://cdn.discordapp.com/attachments/983096812456017934/1082702845700214944/chat.nvim.gif"/>

## TODO
- [ ] automaticly add the right token comment based on the file type
- [ ] maye drop the hacks and use https://github.com/ztjhz/ChatGPTFreeApp (if openai let it be)
