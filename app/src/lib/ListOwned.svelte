<script lang='ts'>
  import { Button } from 'flowbite-svelte'
  import { createEventDispatcher } from 'svelte'
  import type { OwnedAspect } from './types'

  export let aspectName = ''
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

<div class="mb-4">
    {#each ownedAspects as ownedAspect, index}
        <div class="p-1 md:p-2 inline-flex items-center">
            <div class="text-2xl mr-2">{ownedAspect.note}</div>
            <Button color="red" outline on:click={() => deleteOwnedAspect(index)}>X</Button>
        </div>
    {/each}
</div>