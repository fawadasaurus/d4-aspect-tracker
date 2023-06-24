<script lang='ts'>
    import { Card } from 'flowbite-svelte';
    import AddOwned  from './AddOwned.svelte';
    import ListOwned  from './ListOwned.svelte';
    import { createEventDispatcher } from 'svelte';

    const dispatch = createEventDispatcher();
  
    export let aspect;

    function formatText(text) {
      const regex = /({[^}]+})/g;
      return text.replace(regex, '<strong>$1</strong>');
    }

    function handleAspectUpdated() {
      ownedAspects = JSON.parse(localStorage.getItem(aspect.name)) || [];
      dispatch('aspectUpdated');
    }

    $: ownedAspects = JSON.parse(localStorage.getItem(aspect.name)) || [];
</script>
  
<Card class="w-96">
    <h3 class="text-2xl font-bold mb-2">{aspect.name}, {aspect.category}</h3>
    <p class="text-base mb-4">{@html formatText(aspect.desc)}</p>
    <p class="text-base mb-4">In codex: {aspect.in_codex ? 'Yes' : 'No'}</p>
  
    <div class="flex">
      <div class="w-1/2 pr-4">
        <ListOwned aspectName={aspect.name} ownedAspects={ownedAspects} on:aspectUpdated={handleAspectUpdated} />
      </div>
      <div class="w-1/2">
        <AddOwned aspectName={aspect.name} ownedAspects={ownedAspects} on:aspectUpdated={handleAspectUpdated} />
      </div>
    </div>
  </Card>