module FFRobot
    module Helpers
        def difference(a, b)
            ha = a.group_by(&:itself).map{|k, v| [k, v.length]}.to_h
            hb = b.group_by(&:itself).map{|k, v| [k, v.length]}.to_h
            hc = ha.merge(hb){|_, va, vb| (va - vb).abs}.inject([]){|a, (k, v)| a + [k] * v}
            return hc
        end
    end
end