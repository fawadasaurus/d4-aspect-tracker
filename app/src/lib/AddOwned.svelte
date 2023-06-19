<script lang='ts'>
    import { Card, Button, Input } from 'flowbite-svelte';
    import { onMount, createEventDispatcher } from 'svelte';
    import type { OwnedAspect, OwnedAspects } from './types';

    export let aspectName = "";
    let ownedAspects: OwnedAspects = {};
    let aspectValue = "";

    const dispatch = createEventDispatcher();

    onMount(() => {
      const ownedAspectsData = localStorage.getItem('ownedAspects');
      if (ownedAspectsData) {
        ownedAspects = JSON.parse(ownedAspectsData);
      }
    });
  
    function addOwnedAspect() {
      const ownedAspect: OwnedAspect = {
        note: aspectValue,
        time: new Date().toLocaleString()
      };
      if (ownedAspects[aspectName]) {
        ownedAspects[aspectName].push(ownedAspect);
      } else {
        ownedAspects[aspectName] = [ownedAspect];
      }
      localStorage.setItem('ownedAspects', JSON.stringify(ownedAspects));
      dispatch('aspectUpdated');
      aspectValue = '';
    }
  </script>
  
  <Card class="p-2 md:p-4">
    <h3 class="text-sm md:text-base">Add Owned Aspect</h3>
    <div class="flex items-center">
      <Input bind:value={aspectValue} placeholder="Enter value" class="text-xs md:text-base mr-2" />
      <Button on:click={addOwnedAspect} class="text-xs md:text-base py-1 px-2">Add</Button>
    </div>
  </Card>