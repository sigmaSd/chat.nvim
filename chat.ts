import { Chat } from "https://deno.land/x/xchat@0.1.0/chat.ts";

if (import.meta.main) {
  const chat = Chat.start();
  console.log("waiting");
  while (!chat.connected) await new Promise((r) => setTimeout(r, 1000));
  console.log("ready");

  const buf = new Uint8Array(1024);
  while (true) {
    const n = await Deno.stdin.read(buf);
    if (!n) continue;
    const input = new TextDecoder().decode(buf.subarray(0, n));
    console.log(await chat.chat(input));
  }
}
