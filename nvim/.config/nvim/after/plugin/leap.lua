require('leap').add_default_mappings()
-- require('leap').opts = {
--     max_phase_one_targets = nil,
--     highlight_unlabeled_phase_one_targets = false,
--     max_highlighted_traversal_targets = 10,
--     case_sensitive = false,
--     equivalence_classes = { ' \t\r\n', },
--     substitute_chars = {},
--     labels = { 's', 't', 'r', 'd', 'g', 'h', 'n', 'a', 'e', 'i', 'l', 'm', 'o', 'u', '/', 'y' },
--     special_keys = {
--         repeat_search = '<enter>',
--         next_phase_one_target = '<enter>',
--         next_target = { '<enter>', ';' },
--         prev_target = { '<tab>', ',' },
--         next_group = '<space>',
--         prev_group = '<tab>',
--         multi_accept = '<enter>',
--         multi_revert = '<backspace>',
--     }
-- }
require('leap').opts.labels = { 's','h','t','e','r','g','n','m', 'u', 'l', 'y', 'f', 'o'  }
require('leap').opts.safe_labels = { 's','h','t','e','r','g','n','m', 'u', 'l', 'y', 'f', 'o'  }
require('leap').opts.case_sensitive = false
require('leap').opts.special_keys.multi_accept = { '<enter>' }
require('leap').opts.special_keys.next_target = { ';' }
require('leap').opts.special_keys.prev_target = { ',' }
