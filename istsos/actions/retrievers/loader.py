# -*- coding: utf-8 -*-
# istSOS. See https://istsos.org/
# License: https://github.com/istSOS/istsos3/master/LICENSE.md
# Version: v3.0.0

import asyncio
import istsos
from istsos.actions.retrievers.retriever import Retriever
from istsos.entity.loader import Loader as ELoader


class Loader(Retriever):
    @asyncio.coroutine
    def process(self, request):

        request['loader'] = ELoader(json_source=(
                yield from istsos.get_state()
            ).get_loader()
        )

        request['loader']['password'] = '********'
