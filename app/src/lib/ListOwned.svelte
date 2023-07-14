<script lang="ts">
  import { Button } from 'flowbite-svelte'
  import { createEventDispatcher } from 'svelte'
  import type { OwnedAspect } from './types'

  export let aspectName
  export let ownedAspects: OwnedAspect[] = []

  const dispatch = createEventDispatcher()

  function deleteOwnedAspect(index: number) {
    const ownedAspectData = localStorage.getItem(aspectName)
    if (ownedAspectData) {
      ownedAspects = JSON.parse(ownedAspectData)

      let ownedAspectList = ownedAspects
      ownedAspectList.splice(index, 1)

      if (ownedAspectList.length === 0) {
        localStorage.removeItem(aspectName)
      } else {
        localStorage.setItem(aspectName, JSON.stringify(ownedAspects))
      }

      dispatch('aspectUpdated')
    }
  }
</script>

<div class="mb-4 grid grid-cols-2 gap-4">
  {#each ownedAspects as ownedAspect, index}
    <div class="p-1 md:p-2 flex items-center">
      <div class="flex flex-col">
        <div class="text-xl mb-2">{ownedAspect.note}</div>
        <div class="text-sm">{ownedAspect.note_long || ''}</div>
      </div>
      <Button
        class="ml-auto"
        color="red"
        outline
        on:click={() => deleteOwnedAspect(index)}
      >
        X
      </Button>
    </div>
  {/each}
</div>
