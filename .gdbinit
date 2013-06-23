set history save on
python
import sys
sys.path.insert(0, '/home/prevot/dev/gdbSTLsupport')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
