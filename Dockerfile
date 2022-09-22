FROM klakegg/hugo:0.101.0-onbuild AS hugo

FROM pierrezemb/gostatic
COPY --from=hugo /target /srv/http/