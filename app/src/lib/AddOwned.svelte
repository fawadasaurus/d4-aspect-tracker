<script lang='ts'>
  import { Button, Input } from "flowbite-svelte";
  import { createEventDispatcher } from "svelte";
  import type { OwnedAspect, ItemType } from "./types";

  export let aspectName = "";
  export let ownedAspects: OwnedAspect[] = [];

  let aspectValue = "";

  const dispatch = createEventDispatcher();

  function addOwnedAspect(type: ItemType = "OTHER") {
    if (aspectValue === "") return;
    const divider = type === "AMULET" ? 1.5 : type === "2H-WEAPON" ? 2 : 1;
    const ownedAspect: OwnedAspect = {
      note: String((Math.abs(Number(aspectValue))) / divider),
      time: new Date().toLocaleString()
    };
    const ownedAspectData = localStorage.getItem(aspectName);
    if (ownedAspectData) {
      ownedAspects = JSON.parse(ownedAspectData);
    }
    ownedAspects.push(ownedAspect);
    ownedAspects.sort((a, b) => b.note - a.note);

    localStorage.setItem(aspectName, JSON.stringify(ownedAspects));
    dispatch("aspectUpdated");
    aspectValue = "";
  }
</script>

<div>
    <div class="flex">
        <Input bind:value={aspectValue} type="number" min="0"
               inputmode="numeric" class="flex-grow mr-2"/>
        <Button on:click={() => addOwnedAspect("2H-WEAPON")} class="flex-shrink-0" color="yellow" outline>2-Hand
        </Button>
        <Button on:click={()=>addOwnedAspect("AMULET")} class="mx-2" color="yellow" outline>Amulet</Button>
        <Button on:click={() => addOwnedAspect()} color="yellow" outline>Other</Button>
    </div>
</div>