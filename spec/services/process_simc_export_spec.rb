# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessSimcExport do
  let(:simc_export) do
    <<~SIMC
      # Laladaku - Unholy - 2022-12-16 13:25 - US/Sargeras
      # SimC Addon 10.0.2-04
      # WoW 10.0.2.47120, TOC 100002
      # Requires SimulationCraft 1000-01 or newer

      deathknight="Laladaku"
      level=70
      race=human
      region=us
      server=sargeras
      role=attack
      professions=alchemy=150/inscription=1
      spec=unholy

      talents=BwPAdLUHklrTr3hBIcYWdbnCGDAIIJJBSQkIRIJSSSkAAAAAAAAAAKJJhIAAgEpkIRSSikA

      # Saved Loadout: mythic +
      # talents=BwPAdLUHklrTr3hBIcYWdbnCGDAiQSCJiERkIRIkkIRAAAAAAAAAAQSSIRSKAAkiUOQkkkIJA
      # Saved Loadout: single
      # talents=BwPAdLUHklrTr3hBIcYWdbnCGDAIIJJBSQkIRIJSSSkAAAAAAAAAAKJJhIAAgEpkIRSSikA
      # Saved Loadout: mythic+ disease
      # talents=BwPAdLUHklrTr3hBIcYWdbnCGDAiEJJk0iECiEhQSiEBAAAAAAAAAAJJJCJpBAQKSJkkkDIJHA

      head=,id=109987,bonus_id=8966/7977/6652/7936/8822/8820/9144/3277/8767
      neck=,id=133633,bonus_id=8964/7977/6652/7936/8783/9144/3264/8767
      shoulder=,id=193686,bonus_id=7977/6652/8813/1594/8767
      back=,id=193712,enchant_id=6593,bonus_id=8964/7977/6652/8822/8819/9144/1607/8767
      chest=,id=193753,enchant_id=6625,bonus_id=7977/41/8816/1594/8767
      shirt=,id=89195
      wrist=,id=109878,enchant_id=6577,bonus_id=8964/7977/6652/7936/8822/8819/9144/3270/8767
      hands=,id=201953,bonus_id=8851/8852/8800/8850/8793,crafted_stats=40/36
      waist=,id=193650,bonus_id=8961/7977/6652/7937/8822/8818/9144/1598/8767
      legs=,id=134271,enchant_id=6493,bonus_id=8965/7977/6652/8822/8820/9144/3268/8767
      feet=,id=189537,bonus_id=8837/8838/4785/8802/8850/8793,crafted_stats=32/49
      finger1=,id=202119,enchant_id=6554
      finger2=,id=133638,enchant_id=6561,bonus_id=8961/7977/6652/7937/9144/3255/8767
      trinket1=,id=136975,bonus_id=8965/7977/6652/9144/3268/8767
      trinket2=,id=198451,bonus_id=6652/1440/5864/8767
      main_hand=,id=192031,enchant_id=3368,bonus_id=40/1478/5865/8767

      ### Gear from Bags
      #
      # Custodian's Medallion of Delusion (372)
      # neck=,id=193647,bonus_id=7977/6652/7936/8783/1594/8767
      #
      # Tuskarr Bone Necklace (372)
      # neck=,id=193666,bonus_id=7977/6652/7936/8783/1594/8767
      #
      # Potion-Stained Cloak (346)
      # back=,id=193712,bonus_id=7978/7975/6652/8815,drop_level=70
      #
      # Breastplate of Soaring Terror (372)
      # chest=,id=193753,bonus_id=7977/6652/8816/1594/8767
      #
      # Wyrmforged Armplates (372)
      # wrist=,id=192012,bonus_id=6652/7936/1478/5861/8767
      #
      # Ravenous Omnivore's Girdle (372)
      # waist=,id=193760,bonus_id=7977/6652/7936/8814/1594/8767
      #
      # Venerated Professor's Greaves (376)
      # legs=,id=193706,bonus_id=8961/7977/6652/8822/8820/9144/1598/8767
      #
      # Drake Hunter's Greaves (372)
      # legs=,id=193694,bonus_id=7977/6652/8816/1594/8767
      #
      # Blaze Ring (369)
      # finger1=,id=200159,bonus_id=6652/7936/1472/5864/8766
      #
      # Circle of Ascended Frost (372)
      # finger1=,id=193731,enchant_id=6554,bonus_id=7977/6652/7936/1594/8767
      #
      # Primal Ritual Shell (379)
      # trinket1=,id=200563,bonus_id=6652/1481/5865/8767
      #
      # Dragon Games Equipment (379)
      # trinket1=,id=193719,bonus_id=8962/7977/6652/9144/1601/8767
      #
      # Dragon Games Equipment (379)
      # trinket1=,id=193719,bonus_id=8962/7977/6652/9144/1601/8767
      #
      # Idol of Trampling Hooves (372)
      # trinket1=,id=193679,bonus_id=7977/6652/1594/8767
      #
      # Ley-Line Tracer (372)
      # main_hand=,id=193638,enchant_id=3368,bonus_id=7977/6652/1594/8767
      #
      # Undertow Tideblade (372)
      # main_hand=,id=193742,enchant_id=3368,bonus_id=7977/6652/1594/8767
      #
      # Protector's Molten Cudgel (369)
      # main_hand=,id=200169,bonus_id=6652/1472/5864/8766
      #
      # Cavalry's Charging Lance (372)
      # main_hand=,id=197922,bonus_id=6652/1475/5864/8767
      #
      # Protector's Molten Cudgel (379)
      # main_hand=,id=200169,bonus_id=6652/1481/5865/8767
      #
      # Sargha's Smasher (372)
      # main_hand=,id=193779,enchant_id=3368,bonus_id=7977/6652/1594/8767
      #
      # Ohn'ahran Greatsword (333)
      # main_hand=,id=197701,bonus_id=8768/8769,drop_level=70

      # Checksum: 9baa0f14
    SIMC
  end

  context '.call' do
    it 'returns creates and returns a report' do
      report = described_class.call(simc_export)
      expect(report).to be_a(Simc::Report)
      expect(report.id).to be_present
    end

    context 'on report it returns' do
      it 'has the simc export' do
        report = described_class.call(simc_export)
        expect(report.custom_string).to eq(simc_export)
      end
    end
  end
end
